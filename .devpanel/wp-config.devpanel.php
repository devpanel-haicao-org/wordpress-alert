<?php
/**
 * @file
 * DevPanel WordPress settings overrides.
 *
 * Include this file from wp-config.php after the database settings are defined.
 */

// Override database credentials with DevPanel environment variables.
define('DB_NAME',     getenv('DB_NAME'));
define('DB_USER',     getenv('DB_USER'));
define('DB_PASSWORD', getenv('DB_PASSWORD'));
define('DB_HOST',     getenv('DB_HOST') . ':' . getenv('DB_PORT'));
define('DB_CHARSET',  'utf8mb4');
define('DB_COLLATE',  '');

// Generate unique authentication keys and salts.
$devpanel_salt = hash('sha256', serialize([DB_NAME, DB_USER, DB_HOST]));
define('AUTH_KEY',         $devpanel_salt . '_auth');
define('SECURE_AUTH_KEY',  $devpanel_salt . '_secure_auth');
define('LOGGED_IN_KEY',    $devpanel_salt . '_logged_in');
define('NONCE_KEY',        $devpanel_salt . '_nonce');
define('AUTH_SALT',        $devpanel_salt . '_auth_salt');
define('SECURE_AUTH_SALT', $devpanel_salt . '_secure_auth_salt');
define('LOGGED_IN_SALT',   $devpanel_salt . '_logged_in_salt');
define('NONCE_SALT',       $devpanel_salt . '_nonce_salt');

// WordPress database table prefix.
$table_prefix = 'wp_';

// WordPress debugging configuration.
define('WP_DEBUG',     false);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);

// Performance settings.
define('WP_MEMORY_LIMIT',     '256M');
define('WP_MAX_MEMORY_LIMIT', '512M');
define('DISALLOW_FILE_EDIT',  true);

// Set WP_HOME and WP_SITEURL dynamically from the current request.
if (isset($_SERVER['HTTP_HOST'])) {
    $scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
    $current_host = $_SERVER['HTTP_HOST'];
    define('WP_HOME',    $scheme . '://' . $current_host);
    define('WP_SITEURL', $scheme . '://' . $current_host);
} elseif (getenv('DP_HOSTNAME')) {
    define('WP_HOME',    'https://' . getenv('DP_HOSTNAME'));
    define('WP_SITEURL', 'https://' . getenv('DP_HOSTNAME'));
}

// Absolute path to the WordPress directory.
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}