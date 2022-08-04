<?php
/**
 * WooCommerce Compatibility.
 *
 * @package zakra
 */

// Exit if accessed directly.
defined( 'ABSPATH' ) || exit;

if ( ! class_exists( 'Zakra_WooCommerce' ) ) {

	/**
	 * Class Zakra_WooCommerce
	 */
	class Zakra_WooCommerce {

		/**
		 * Zakra_WooCommerce constructor.
		 */
		public function __construct() {

			add_action( 'after_setup_theme', array( $this, 'woocommerce_setup' ) );
			add_action( 'wp_enqueue_scripts', array( $this, 'woocommerce_scripts' ) );
			add_filter( 'body_class', array( $this, 'woocommerce_active_body_class' ) );

			// Remove WC wrappers.
			remove_action( 'woocommerce_before_main_content', 'woocommerce_output_content_wrapper', 10 );
			remove_action( 'woocommerce_after_main_content', 'woocommerce_output_content_wrapper_end', 10 );

			add_action( 'woocommerce_before_main_content', array( $this, 'woocommerce_wrapper_before' ) );
			add_action( 'woocommerce_after_main_content', array( $this, 'woocommerce_wrapper_after' ) );
			add_filter( 'woocommerce_add_to_cart_fragments', array( $this, 'woocommerce_header_add_to_cart_fragment' ) );
			add_filter( 'zakra_woocommerce_header_cart', array( __CLASS__, 'woocommerce_header_cart' ) );
			add_filter( 'woocommerce_show_page_title', array( $this, 'woocommerce_page_title' ) );
			add_action( 'wp_loaded', array( $this, 'woocommerce_remove_product_title' ) );

			// Remove WC sidebar.
			remove_action( 'woocommerce_sidebar', array( $this, 'woocommerce_get_sidebar' ), 10 );

			add_filter( 'zakra_get_sidebar', array( $this, 'get_sidebar' ), 15 );
		}

		/**
		 * WooCommerce setup function.
		 *
		 * @link https://docs.woocommerce.com/document/third-party-custom-theme-compatibility/
		 * @link https://github.com/woocommerce/woocommerce/wiki/Enabling-product-gallery-features-(zoom,-swipe,-lightbox)-in-3.0.0
		 *
		 * @return void
		 */
		public function woocommerce_setup() {
			add_theme_support( 'woocommerce' );
			add_theme_support( 'wc-product-gallery-zoom' );
			add_theme_support( 'wc-product-gallery-lightbox' );
			add_theme_support( 'wc-product-gallery-slider' );
		}

		/**
		 * WooCommerce scripts and styles.
		 *
		 * @return void
		 */
		public function woocommerce_scripts() {
			wp_enqueue_style( 'zakra-woocommerce-style', ZAKRA_PARENT_URI . '/assets/css/woocommerce.css', '', ZAKRA_THEME_VERSION );

			add_filter( 'zakra_dynamic_theme_wc_css', array( 'Zakra_Dynamic_CSS', 'render_wc_output' ) );

			$theme_wc_dynamic_css = apply_filters( 'zakra_dynamic_theme_wc_css', '' );
			wp_add_inline_style( 'zakra-woocommerce-style', $theme_wc_dynamic_css );
		}

		/**
		 * Add 'woocommerce-active' class to the body tag.
		 *
		 * @param  array $classes CSS classes applied to the body tag.
		 * @return array $classes modified to include 'woocommerce-active' class.
		 */
		public function woocommerce_active_body_class( $classes ) {

			$classes[] = 'woocommerce-active';

			return $classes;
		}

		/**
		 * Before Content.
		 *
		 * Wraps all WooCommerce content in wrappers which match the theme markup.
		 *
		 * @return void
		 */
		public function woocommerce_wrapper_before() {
			?>
			<div id="primary" class="content-area">
			<?php
		}

		/**
		 * After Content.
		 *
		 * Closes the wrapping divs.
		 *
		 * @return void
		 */
		public function woocommerce_wrapper_after() {
			?>
			</div><!-- #primary -->
			<?php
		}

		/**
		 * After Content.
		 *
		 * WooCommerce shopping cart.
		 *
		 * @param array $fragments Section to refresh via AJAX.
		 * @return array
		 */
		public function woocommerce_header_add_to_cart_fragment( $fragments ) {

			ob_start();

			echo self::woocommerce_cart_link(); // phpcs:ignore WordPress.Security.EscapeOutput.OutputNotEscaped

			$fragments['.cart-page-link'] = ob_get_clean();

			return $fragments;
		}

		/**
		 * Cart Link.
		 *
		 * Displayed a link to the cart including the number of items present and the cart total.
		 *
		 * @return string
		 */
		public static function woocommerce_cart_link() {

			$output          = '<a class="cart-page-link" href="' . esc_url( wc_get_cart_url() ) . '" title="' . __( 'View your shopping cart', 'zakra' ) . '">';
			$item_count_text = sprintf(
				/* translators: number of items in the mini cart. */
				'%d',
				WC()->cart->get_cart_contents_count()
			);
			$output .= '<i class="tg-icon tg-icon-shopping-cart"></i>';
			$output .= '<span class="count">' . esc_html( $item_count_text ) . '</span>';
			$output .= '</a>';

			return $output;
		}

		/**
		 * Display Header Cart.
		 *
		 * @return string
		 */
		public static function woocommerce_header_cart() {

			$output = '';

			if ( is_cart() ) {
				$class = 'current-menu-item';
			} else {
				$class = '';
			}

			$output .= '<li class="menu-item tg-menu-item tg-menu-item-cart ' . $class . '">';
			$output .= self::woocommerce_cart_link();
			$output .= '</li>';

			return $output;
		}

		/**
		 * Manage WooCommerce page title.
		 *
		 * @return bool
		 */
		public function woocommerce_page_title() {

			if ( 'page-header' === get_theme_mod( 'zakra_page_title_enabled', 'page-header' ) ) {
				return false;
			}

			return true;
		}

		/**
		 * Remove product title if it's shown in page header.
		 */
		public function woocommerce_remove_product_title() {

			if ( 'page-header' === get_theme_mod( 'zakra_page_title_enabled', 'page-header' ) ) {
				remove_action( 'woocommerce_single_product_summary', 'woocommerce_template_single_title', 5 );
			}
		}

		/**
		 * Get sidebar for WC pages based on the current layout.
		 *
		 * @param $sidebar
		 * @return mixed|string
		 */
		public function get_sidebar( $sidebar ) {

			if (
				is_woocommerce() &&
				'tg-site-layout--left' === zakra_get_current_layout()
			) {
				return 'wc-left-sidebar';
			}

			if (
				( is_woocommerce() && 'tg-site-layout--right' === zakra_get_current_layout() ) ||
				( is_woocommerce() && 'tg-site-layout--2-sidebars' === zakra_get_current_layout() )
			) {
				return 'wc-right-sidebar';
			}

			return $sidebar;
		}
	}

	new Zakra_WooCommerce();
}
