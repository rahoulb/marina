<?php 
/**
 * @package WordPress
 * Template Name: Members Search
 */

get_header(); ?>
</div>
<div class="sect-head-bg membersearch">
	<div class="sect-head-bg-tab">
	<!-- SEARCH FORM-->
  <div class="container membersearch">
    <div class="row">
      <div class="span12">
        <div class="mpg-sect-heads">
          <div class="container">
            <span>MEMBERS DIRECTORY</span>
          </div>
        </div>
        
        <div class="membersearch-container">
        
          <div class="membersearch-left">
            <div class="membersearch-alpha">
              <input name="" type="text" placeholder="Enter a last name" data-bind="value: membersDb.lastName"/>
              <div class="alpha"><div>
<a href="#">A</a><a href="#">B</a><a href="#">C</a><a href="#">D</a><a href="#">E</a><a href="#">F</a><a href="#">G</a><a href="#">H</a><a href="#">I</a><a href="#">J</a><a href="#">K</a><a href="#">L</a><a href="#">M</a><a href="#">N</a><a href="#">O</a><a href="#">P</a><a href="#">Q</a><a href="#">R</a><a href="#">S</a><a href="#">T</a><a href="#">U</a><a href="#">V</a><a href="#">W</a><a href="#">X</a><a href="#">Y</a><a href="#">Z</a></div></div>
              <div class="mpg-clear"></div>
              </div>
            <div class="mpg-clear"></div>
            </div>
            
            <div class="membersearch-filter">
              <ul>
                <li class="li-membersearch-filter">Filter by:</li>
                <li><a href="#">Roles</a>
                  <ul class="membersearch-rolls">
                    <div class="membersearch-pointer"></div>
                      <!-- ko foreach: fieldDefinitionsDb.roles -->
                      <li><input type="checkbox" class="role" data-bind="attr: { title: $data }"/><label data-bind="text: $data"></label></li>
                      <!-- /ko -->
                      <div class="mpg-clear"></div>
                    </ul>
                </li>
                
                <li><a href="#">Genre</a>
                  <ul class="membersearch-genre">
                    <div class="membersearch-pointer"></div>
                      <!-- ko foreach: fieldDefinitionsDb.genres -->
                      <li><input type="checkbox" class="genre" data-bind="attr: { title: $data }"/><label data-bind="text: $data"></label></li>
                      <!-- /ko -->
                    <div class="mpg-clear"></div>
                  </ul>
                </li> 
                
                <li><a href="#">Instruments</a>
                  <ul class="membersearch-instruments">
                    <div class="membersearch-pointer"></div>
                      <!-- ko foreach: fieldDefinitionsDb.instruments -->
                      <li><input type="checkbox" class="instrument" data-bind="attr: { title: $data }"/><label data-bind="text: $data"></label></li>
                      <!-- /ko -->
                    <div class="mpg-clear"></div>
                  </ul>
                </li>
                
                <li><a href="#">Facilities</a>
                  <ul class="membersearch-facilities">
                    <div class="membersearch-pointer"></div>
                      <!-- ko foreach: fieldDefinitionsDb.facilities -->
                      <li><input type="checkbox" class="facility" data-bind="attr: { title: $data }"/><label data-bind="text: $data"></label></li>
                      <!-- /ko -->
                    <div class="mpg-clear"></div>
                  </ul>
                </li>
                
                <li class="li-membersearch-intern"><a href="#">Accept Interns</a>
                  <ul class="membersearch-intern">
                    <div class="membersearch-pointer"></div>
                      <li><input name="" type="checkbox" data-bind="checked: membersDb.acceptsInterns" id="skill_401"/><label for="skill_401">Check this box, then filter, to show a list of MPG members who accept interns</label></li>
                    <div class="mpg-clear"></div>
                  </ul>
                </li>
              </ul>
            </div>
          </div>
          <div class="membersearch-right">
          <input value="Search members now" type="submit" data-bind="click: membersDb.doSearch"/>
          </div>
          <div class="mpg-clear"></div>
      </div>
    </div>
  </div>
  </div>
</div>
  
  <!-- CONTINUE PAGE-->
  <div class="container membercontent">
    <div class="row">
      <div class="span8">
      
    	<!-- Part 1 -->
				<?php if ( have_posts() ) : while ( have_posts() ) : the_post(); ?>
        <div class="the_content">
          <h1><?php the_title(); ?></h1>
					<?php the_content(); ?>
    		</div>
        <?php endwhile; else: ?>
          <p><?php _e('Sorry, this page does not exist.'); ?></p>
        <?php endif; ?>
    	<!-- /Part 1 -->
      
    	<!-- Part 2 -->
      <div data-bind="ifnot: membersDb.selected">
        <h1 class="the_title">We have <span class="the_title" data-bind="text: membersDb.items().length"></span> results for your search!</h1>
        <ul class="membersearch-list">
          <!-- ko foreach: membersDb.items -->
          <li>
            <a href="#"><img src="http://amba-design.com/mpg/wp-content/uploads/2013/09/andrew-hunt.jpg"  align="left"/></a>
            <h3 data-bind="text: name"></h3>
            <a href="#" class="twitter_bs btn btn-large" data-bind="click: select">View <span data-bind="text: firstName"></span>'s Profile</a>
          </li>
          <!-- /ko -->
          <div class="mpg-clear"></div>
        </ul>
      </div>
    	<!-- /Part 2 -->

    	<!-- Part 3 -->
      <div class="member-profile-container" data-bind="appearif: membersDb.selected">
        <!-- ko with: membersDb.selected -->
        <div class="pull-right" class="the_content"><a href="#" data-bind="click: deselect">&times;</a></div>
      	<div class="member-profile-avatar">
          <img src="http://amba-design.com/mpg/wp-content/uploads/2013/09/andrew-hunt.jpg" />      
        </div>
        <div class="member-profile-details">
          <h1 data-bind="text: name"></h1>
          <p class="member-profile-member" data-bind="text: subscriptionPlan"></p>
          <div class="member-profile-social">Social:</div>
          <div class="member-profile-social-r">
            <div class="socialshare">
              <ul>
                <li class="head-linkedin" onclick="window.open('#','_blank');"></li>
                <li class="head-twitter" onclick="window.open('#','_blank');"></li>
                <li class="head-fb" onclick="window.open('#','_blank');"></li>
                <li class="head-youtube" onclick="window.open('#','_blank');"></li>
                <li class="head-myspace" onclick="window.open('#','_blank');"></li>
              </ul>
            </div>
          </div>
          <div class="member-profile-email">Email:</div>
          <div class="member-profile-email-r"><a data-bind="attr: { href: 'mailto:' + email() }"></a></div>
          <div class="member-profile-web">Website:</div>
          <div class="member-profile-web-r"><a data-bind="attr: { href: webAddress }"></a></div>
          <div class="member-profile-skype">Skype:</div>
          <div class="member-profile-skype-r"><img src="http://mystatus.skype.com/smallclassic/mickglossop" style="border: none;" width="114" height="20" alt="My status"></div>
        </div>
        <div class="mpg-clear"></div>
        
        <div class="member-profile-rolls">
        <ul>
          <li>
            <h3>Rolls</h3>
            <p>Producer, Engineer, Programmer, Musician, Mixer, Re-Mixer, Education, Audio Tech</p>
          </li>
          <li>
            <h3>Instruments</h3>
            <p>Guitar, Bass, Vocals, Keyboards, Percussion</p>
          </li>
          <li>
            <h3>facilities</h3>
            <p>Studio/single recording room, Pro Tools HD, Logic Studio</p>
          </li>
          <li>
            <h3>Genre</h3>
            <p>Pop, Folk, Rock, Blues, Film, Multimedia, Ambient, World, Alternative, Jazz, Country, Soul, Electronic, Heavy Metal, Reggae, Punk/Thrash, Indie, Dance, Chill, Dub</p>
          </li>
        </ul>
        <div class="mpg-clear"></div>
        
        <div class="member-profile-management">
          <h3>Management</h3> 
          <strong>Name:</strong> <span data-bind="text: managementName"></span>
          <strong class="title">Company:</strong> <span data-bind="text: managementCompany"></span>
          <strong class="title">Email:</strong> <span data-bind="text: managementEmail"></span>
        </div>
      </div>
      
      <div class="the_content" data-bind="html: biography"></div>
      
      	<!-- Audio uploads - I haven't the foggiest how your gonna do this - Wordpress has a oembed function to recognise mp3 URL's and replace them with players - can you utilise that in anyway? -->
        <div class="the_music">
          <h3>Music</h3>
          <p>A heading here</p>
          <audio id="audioplayer-a86fc2943bc375e819712b917c6487d2" controls="controls" preload="preload">
            <source src="http://s3.amazonaws.com/music-producers-guild/file_attachments/13083/MPG_goNORTH_panel.mp3" type="audio/mpeg">
            <embed type="application/x-shockwave-flash" flashvars="audioUrl=http://s3.amazonaws.com/music-producers-guild/file_attachments/13083/MPG_goNORTH_panel.mp3" 
            src="http://amba-design.com/mpg/wp-content/plugins/pb-oembed-html5-audio-with-cache-support/3523697345-audio-player.swf" width="400" height="27" quality="best">
          </audio>
          <p>A heading here</p>
          <audio id="audioplayer-a86fc2943bc375e819712b917c6487d2" controls="controls" preload="preload">
            <source src="http://s3.amazonaws.com/music-producers-guild/file_attachments/13083/MPG_goNORTH_panel.mp3" type="audio/mpeg">
            <embed type="application/x-shockwave-flash" flashvars="audioUrl=http://s3.amazonaws.com/music-producers-guild/file_attachments/13083/MPG_goNORTH_panel.mp3" 
            src="http://amba-design.com/mpg/wp-content/plugins/pb-oembed-html5-audio-with-cache-support/3523697345-audio-player.swf" width="400" height="27" quality="best">
          </audio>
        </div>
        <!-- /ko -->
      </div>
      <!-- /Part 3 -->
    </div>
    <div class="span4">
      <div class="mpg-sidebar mpg-sidebar-container">
        <!-- Latest Members -->
        <div>
          <h2>Latest Members</h2>
          <ul>	
            <!-- ko foreach: latestMembersDb.items -->
            <li><span data-bind="text: name" class="name"></span> <span>Joined <span data-bind="text: createdAt"></span></span></li>
            <!-- /ko -->
          </ul>
        </div>
        <!-- /Latest Members -->
        
        <?php if ( ! dynamic_sidebar( 'Members Directory' ) ) { };?>
        <?php get_template_part( 'includes/widget-control', 'default' ); ?>

      </div>
    </div>
  
  </div>
</div>
<?php get_footer(); ?>
<script type="text/javascript" src="/wp-content/themes/wpbootstrap/js/knockout.js"></script>
<script type="text/javascript" src="/wp-content/themes/wpbootstrap/js/data-access.js"></script>
<script type="text/javascript" src="/wp-content/themes/wpbootstrap/js/bindings.js"></script>
<script type="text/javascript" src="/wp-content/themes/wpbootstrap/js/member-search.js"></script>
