<?php 

add_action('init', 'award_register');
 
function award_register() {
 
	$labels = array(
		'name' => _x('Awards', 'post type general name'),
		'singular_name' => _x('Awards Item', 'post type singular name'),
		'add_new' => _x('Add New', 'awards item'),
		'add_new_item' => __('Add New Awards Item'),
		'edit_item' => __('Edit awards Item'),
		'new_item' => __('New awards Item'),
		'view_item' => __('View awards Item'),
		'search_items' => __('Search awards'),
		'not_found' =>  __('Nothing found'),
		'not_found_in_trash' => __('Nothing found in Trash'),
		'parent_item_colon' => ''
	);
 
	$args = array(
		'labels' => $labels,
		'public' => true,
		'publicly_queryable' => true,
		'show_ui' => true,
		'query_var' => true,
		'menu_icon' => get_stylesheet_directory_uri() . '/article16.png',
		'rewrite' => true,
		'capability_type' => 'post',
		'hierarchical' => false,
		'menu_position' => 2,
		'supports' => array('title','editor','thumbnail')
	  ); 
 
	register_post_type( 'awards' , $args );
}


register_taxonomy("Categories", array("awards"), array("hierarchical" => true, "label" => "Categories", "singular_label" => "Category", "rewrite" => true));
