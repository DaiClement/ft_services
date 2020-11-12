<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wp-admin' );

/** MySQL database password */
define( 'DB_PASSWORD', 'pass' );

/** MySQL hostname */
define( 'DB_HOST', 'mysql_alpine' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );


define('FS_METHOD', 'direct');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '3(%,HuTm+j!JY=Qf<.Cp$9DNDo4=|Vfq1u@b<b>sEPmOCZnqSU:2e6V!|4A1T^>4');
define('SECURE_AUTH_KEY',  'A`?gI_m{E]e4$yNlkov}J</r4!_p!{uGxsn#,YZQ{ (4 $*3x;M9jNvshOp([3Vb');
define('LOGGED_IN_KEY',    'sTG~/<sZ*gyJ;!Ojh,4;&Jh+bmMI9{X$|Fp~n sZsSP?}j?+}O+T>:jK[ g3stL^');
define('NONCE_KEY',        '!E.pWv]?tRzP.lub{+g-aQ<2o)mTMHvG]n(L136j(bGGrYlJfO`UyF/AMd0boMgC');
define('AUTH_SALT',        '4og@J-0$a0x-DvLT$-/s9vHkE6|+g+Z>;c$+J<*,[Q{Sx?=1S3U4}D.ZWo;]58RI');
define('SECURE_AUTH_SALT', 'JlOI9,vKTmaA+3e);y?ilp}Y{xQ5_;7fcs+r~*JM[z#,WT_eBRkBH,2s8,nr4+0N');
define('LOGGED_IN_SALT',   '}+~YsREZ-t}+o#^d[$lnwmyB`rt|ay;wp#[-S|Jn@t~#1&Db]H:CSY6fK}P|Tyo|');
define('NONCE_SALT',       'J`lTdfrVLG.^B)%q]5X2=*}VcA}Qg5jUW&oEptv{K}2.$2yGP<c<Pgr`w|cQL/C ');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
