CREATE TABLE IF NOT EXISTS actions (
  `action` varchar(100) NOT NULL default '',
  `file` varchar(100) NOT NULL default '',
  title varchar(100) NOT NULL default '',
  `right` int(1) NOT NULL default '0',
  box varchar(100) default NULL,
  sub varchar(25) NOT NULL default 'main',
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('news', 'news.pl', 'News', 0, 'verify', 'show', 1);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('settings', 'quick.pl', 'Settings', 5, 'verify', 'main', 2);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('addNews', 'news.pl', 'Neue Nachricht', 0, 'verify', 'addNews', 3);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('admin', 'admin.pl', 'Admin Center', 5, 'verify', 'main', 4);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('delete', 'news.pl', 'News', 5, 'verify', 'deleteNews', 5);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('edit', 'news.pl', 'News', 5, 'verify', 'editNews', 6);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('saveedit', 'news.pl', 'News', 5, 'verify', 'saveedit', 7);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('reply', 'news.pl', 'News', 0, 'verify', 'reply', 8);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('profile', 'profile.pl', 'Profile', 1, 'verify', 'main', 9);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('showEntry', 'tables.pl', 'Datenbank', 5, 'tables', 'showEntry', 10);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('reg', 'reg.pl', 'Registrieren', 0, 'verify', 'reg', 11);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('addReply', 'news.pl', 'News', 0, 'verify', 'addReply', 12);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('showthread', 'news.pl', 'News', 0, 'verify', 'showMessage', 13);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('makeUser', 'reg.pl', 'Registrieren', 0, NULL, 'make', 14);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('verify', 'reg.pl', 'Verify', 0, NULL, 'verify', 15);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('newEntry', 'tables.pl', 'Neuer Eintrag', 5, 'tables', 'newEntry', 16);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('editEntry', 'tables.pl', 'Eintrag bearbeiten', 5, 'tables', 'editEntry', 17);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('showMessage', 'news.pl', 'LZE', 0, 'verify', 'main', 18);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('dropTables', 'tables.pl', 'Datenbank', 5, 'tables', 'dropTables', 20);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('createMenu', 'tables.pl', 'Datenbank', 5, 'tables', 'createMenu', 21);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('saveEntry', 'tables.pl', 'Datenbank', 5, 'tables', 'saveEntry', 23);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('deleteEntry', 'tables.pl', 'Datenbank', 5, 'tables', 'deleteEntry', 24);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('showTables', 'tables.pl', 'Databases', 5, 'tables', 'showTables', 25);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('fulltext', 'search.pl', 'search', 0, 'verify', 'fulltext', 26);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('newTreeviewEntry', 'editTree.pl', 'newTreeViewEntry', 5, 'verify', 'newTreeviewEntry', 27);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('saveTreeviewEntry', 'editTree.pl', 'saveTreeviewEntry', 5, 'verify', 'saveTreeviewEntry', 28);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('editTreeview', 'editTree.pl', 'editTreeview', 5, 'verify', 'editTreeview', 29);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('addTreeviewEntry', 'editTree.pl', 'addTreeviewEntry', 5, 'verify', 'addTreeviewEntry', 30);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('editTreeviewEntry', 'editTree.pl', 'editTreeviewEntry', 5, 'verify', 'editTreeviewEntry', 31);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('deleteTreeviewEntry', 'editTree.pl', 'deleteTreeviewEntry', 5, 'verify', 'deleteTreeviewEntry', 32);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('upEntry', 'editTree.pl', 'upEntry', 5, 'verify', 'upEntry', 33);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('downEntry', 'editTree.pl', 'downEntry', 5, 'verify', 'downEntry', 34);
INSERT INTO actions (action, `file`, title, `right`, box, sub, id) VALUES('links', 'links.pl', 'Bookmarks', 0, 'verify', 'main', 35);
INSERT INTO actions (`action`,`file`,title,`right`,box,sub, id) VALUES ('env', 'env.pl', 'Envoirement Variables', 5, 'verify', 'main',36);
INSERT INTO actions (`action`,`file`,title,`right`,box,sub,id) VALUES ('lostpass', 'login.pl', 'lostpass', 0, NULL, 'lostpass',38);
INSERT INTO actions (`action`,`file`,title,`right`,box,sub,id) VALUES ('getpass', 'login.pl', 'getpass', 0, NULL, 'getpass',39);
INSERT INTO actions (`action`,`file`,title,`right`,box,sub,id) VALUES ('execSql', 'tables.pl', 'execSql', 4, NULL, 'execSql',40);
INSERT INTO actions (`action`,`file`,title,`right`,box,sub,id) VALUES ('showTableDetails', 'tables.pl', 'showTableDetails', 4, NULL, 'showTableDetails',41);
INSERT INTO `actions` (`action`, `file`, `title`, `right`, `box`, `sub`, `id`) VALUES ('showDir', 'files.pl', 'Files', 5, '', 'showDir', 42);
INSERT INTO `actions` (`action`, `file`, `title`, `right`, `box`, `sub`, `id`) VALUES ('openFile', 'files.pl', 'openFile', 5, '', 'openFile', 43);
INSERT INTO `actions` (`action`, `file`, `title`, `right`, `box`, `sub`, `id`) VALUES ('newFile', 'files.pl', 'newFile', 5, '', 'newFile', 44);
INSERT INTO `actions` (`action`, `file`, `title`, `right`, `box`, `sub`, `id`) VALUES ('saveFile', 'files.pl', 'saveFile', 5, '', 'saveFile', 45);
INSERT INTO `actions` (`action`, `file`, `title`, `right`, `box`, `sub`, `id`) VALUES ('sqldump', 'tables.pl', 'mysqldump', 5, 'tables', 'sqldump', 46);
INSERT INTO `actions` (`action`, `file`, `title`, `right`, `box`, `sub`, `id`) VALUES ('translate', 'translate.pl', 'translate', 5, '', 'main', 47);
INSERT INTO `actions` (`action`, `file`, `title`, `right`, `box`, `sub`, `id`) VALUES ('addTranslation', 'translate.pl', 'translate', 5, '', 'addTranslation', 48);
CREATE TABLE IF NOT EXISTS box (
  `file` varchar(100) NOT NULL default '',
  position varchar(8) NOT NULL default 'left',
  `right` int(1) NOT NULL default '0',
  `name` varchar(100) NOT NULL default '',
  `id` int(11) NOT NULL auto_increment,
  `dynamic` varchar(10) default NULL,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
INSERT INTO box (`file`, position, `right`, name, id, dynamic) VALUES('navigation.pl', 'left', 0, 'Navigation', 1, '0');
INSERT INTO box (`file`, position, `right`, name, id, dynamic) VALUES('verify.pl', 'left', 0, 'Verify', 3, 'disabled');
INSERT INTO box (`file`, position, `right`, name, id, dynamic) VALUES('login.pl', 'disabled', 0, 'Login', 4, '0');
INSERT INTO box (`file`, position, `right`, name, id, dynamic) VALUES('tables.pl', 'disabled', 5, 'Datenbank', 10, 'right');
CREATE TABLE IF NOT EXISTS cats (
  `name` varchar(100) NOT NULL default '',
  `right` int(11) NOT NULL default '0',
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
INSERT INTO cats (name, `right`,  id) VALUES('News', 0,  1);
INSERT INTO cats (name, `right`,  id) VALUES('member', 1, 2);
CREATE TABLE IF NOT EXISTS navigation (
  title varchar(100) NOT NULL default '',
  `action` varchar(100) NOT NULL default '',
  src varchar(100) NOT NULL default '',
  `right` int(11) NOT NULL default '0',
  position varchar(5) NOT NULL default 'left',
  submenu varchar(100) default NULL,
  `id` int(11) NOT NULL auto_increment,
  target int(11) default NULL,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
INSERT INTO navigation (title, action, src, `right`, position, submenu, id, target) VALUES('News', 'news', 'news.png', 0, 'top', '', 1, 0);
INSERT INTO navigation (title, action, src, `right`, position, submenu, id, target) VALUES('Admin', 'admin', 'admin.png', 5, '8', 'submenuadmin', 2, 0);
INSERT INTO navigation (title, action, src, `right`, position, submenu, id, target) VALUES('Einstellungen', 'profile', 'profile.png', 1, '6', '', 3, 0);
INSERT INTO navigation (title, action, src, `right`, position, submenu, id, target) VALUES('Bookmarks', 'links', 'link.png', 0, 'top', '', 5, 0);
INSERT INTO navigation (title,`action`,src,`right`,position,submenu,id,target) VALUES ('Impressum', 'impressum', 'about.png', 0, '7', '',6,0);

CREATE TABLE IF NOT EXISTS news (
  title varchar(100) NOT NULL default '',
  body text NOT NULL,
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `user` text NOT NULL,
  `right` int(11) NOT NULL default '0',
  attach varchar(100) NOT NULL default '0',
  cat varchar(25) NOT NULL default 'news',
  `action` varchar(50) NOT NULL default 'main',
  sticky int(1) NOT NULL default '0',
  `id` int(11) NOT NULL auto_increment,
  format varchar(10) NOT NULL default 'bbcode',
  PRIMARY KEY  (id),
  FULLTEXT KEY title (title,body)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
INSERT INTO news (title, body, date, `user`, `right`, attach, cat, action, sticky, id) VALUES('Login as', 'Name: admin\r\npassword: testpass', '2007-04-23 19:06:42', 'admin', 0, '0', '/news', 'news', 0, 1);
CREATE TABLE IF NOT EXISTS querys (
  title varchar(100) NOT NULL default '',
  description text NOT NULL,
  `sql` text NOT NULL,
  `return` varchar(100) NOT NULL default 'fetch_array',
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS replies (
  title varchar(100) NOT NULL default '',
  body text NOT NULL,
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `user` text NOT NULL,
  `right` int(10) NOT NULL default '0',
  attach varchar(100) NOT NULL default '0',
  refererId varchar(50) NOT NULL default '',
  sticky int(1) NOT NULL default '0',
  `id` int(11) NOT NULL auto_increment,
  format varchar(10) NOT NULL default 'bbcode',
  cat varchar(25) NOT NULL default 'replies',
  PRIMARY KEY  (id),
  FULLTEXT KEY title (title,body)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS submenuadmin (
  title varchar(100) NOT NULL default '',
  `action` varchar(100) NOT NULL default '',
  src varchar(100) NOT NULL default 'link.gif',
  `right` int(11) NOT NULL default '0',
  submenu varchar(100) default NULL,
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
INSERT INTO submenuadmin (title, action, src, `right`, submenu, id) VALUES('Settings', 'settings', 'link.gif', 5, NULL, 1);
INSERT INTO submenuadmin (title, action, src, `right`, submenu, id) VALUES('Databases', 'showTables', 'gear.png', 5, '', 8);
INSERT INTO submenuadmin (title, action, src, `right`, submenu, id) VALUES('Navigation', 'editTreeview', '', 5, '', 9);
INSERT INTO submenuadmin (title,`action`,src,`right`,submenu,id) VALUES ('Envoirement Variables', 'env', 'link.gif', 5, NULL,10);
INSERT INTO submenuadmin (title, action, src, `right`, submenu, id) VALUES('Bookmarks', 'linkseditTreeview', 'link.gif', 5, '', 12);
INSERT INTO submenuadmin (title, action, src, `right`, submenu, id) VALUES('Files', 'showDir', 'link.gif', 5, '', 15);
INSERT INTO submenuadmin (title, action, src, `right`, submenu, id) VALUES('Translate', 'translate', 'link.gif', 5, '', 16);
CREATE TABLE IF NOT EXISTS trash (
  `table` varchar(50) NOT NULL default '',
  oldId bigint(50) NOT NULL default '0',
  title varchar(100) NOT NULL default '',
  `body` text NOT NULL,
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `user` text NOT NULL,
  `right` int(11) NOT NULL default '0',
  attach varchar(100) NOT NULL default '0',
  cat varchar(25) NOT NULL default 'main',
  `action` varchar(50) NOT NULL default 'news',
  sticky int(1) NOT NULL default '0',
  `id` int(11) NOT NULL auto_increment,
  format varchar(10) NOT NULL default 'bbcode',
  PRIMARY KEY  (id),
  FULLTEXT KEY title (title,body)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS users (
  pass text NOT NULL,
  `user` varchar(25) NOT NULL default '',
  `date` date NOT NULL default '0000-00-00',
  email varchar(100) NOT NULL default '',
  `right` int(11) NOT NULL default '0',
  `name` varchar(100) NOT NULL default '',
  firstname varchar(100) NOT NULL default '',
  street varchar(100) default NULL,
  city varchar(100) default NULL,
  postcode varchar(20) default NULL,
  phone varchar(50) default NULL,
  sid varchar(200) default NULL,
  ip varchar(50) default NULL,
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
INSERT INTO users (pass, `user`, date, email, `right`, name, firstname, street, city, postcode, phone, sid, ip, id) VALUES('fe7374a18d3f8ca9547e49aa39a2dd67', 'admin', '0000-00-00', 'lindnerei@o2online.de', 5, 'Nachname', 'Vorname', 'Strasse', 'Stadt', 'Postleitzahl', 'Telefonnummer', '0008e525bc0894a780297b7f3aed6f58', '::1', 1);
INSERT INTO users (pass, `user`, date, email, `right`, name, firstname, street, city, postcode, phone, sid, ip, id) VALUES('guest', 'guest', '0000-00-00', 'guest@lindnerei.de', 0, 'guest', 'guest', 'guest', 'guest', '57072', '445566', 'hghsdf7', 'dd', 2);
INSERT INTO actions (`action`,`file`,title,`right`,box,sub) VALUES ('impressum', 'impressum.pl', 'Impressum', 0, 'impressum', 'main');
INSERT INTO box (`file`,position,`right`,name,dynamic) VALUES ('impressum.pl', 'disabled', 0, 'Impressum', 'right');
CREATE TABLE IF NOT EXISTS exploit (
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  referer text NOT NULL,
  remote_addr text NOT NULL,
  query_string text NOT NULL,
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
CREATE TABLE IF NOT EXISTS flood (
  remote_addr text NOT NULL,
  ti text NOT NULL,
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

