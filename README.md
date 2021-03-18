# CU Scholar Repository

Samvera Hyrax application for the deployment to k8s cluster.

### Branch Management

     <feature branch> --> develop --> release --> master

     `develop` is used for local development.
     Note:
      - For local development, make sure to comment out the line 15,16,17 in config/routes.rb and uncomment line 22.
      - Before merging to release, undo the previous step above to activate SAML.
     `release` includes SAML --> Testing Branch
     `master` production Branch - Requires PR to merge to master


### Setup Development Environment

1. Dependency
     * Java 1.8 This requirement is needed to start solr search
     * Ruby and rails.... on todo for addition dependencies.


### Debug Environment

    $ bin/rails hydra:server



TODO List !

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

RDS database see secrets for connections

* Database initialization

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...



mast4541@cu-genvpn-tcom-10:~/github/culibraries/ir-scholar$ bin/rails generate blacklight_oai_provider:install
Running via Spring preloader in process 65747
      insert  app/models/solr_document.rb
      insert  app/controllers/catalog_controller.rb
      insert  config/routes.rb
      insert  config/routes.rb


      aom			freetype		jenv			libogg			nettle			rav1e			unbound
autoconf		frei0r			jpeg			libpng			nghttp2			rbenv			webp
aws-es-proxy		fribidi			jq			libsamplerate		node			readline		wget
aws-iam-authenticator	gdbm			json-c			libsndfile		oniguruma		redis			x264
bash			gettext			kubernetes-cli		libsodium		opencore-amr		rtmpdump		x265
bash-completion		giflib			lame			libsoxr			openjdk			rubberband		xvid
bdw-gc			glib			leptonica		libtasn1		openjpeg		ruby-build		xz
c-ares			gmp			libao			libtiff			openssl@1.1		saml2aws		yarn
cairo			gnutls			libass			libtool			opus			sdl2			zeromq
copilot-cli		gobject-introspection	libbluray		libunistring		p11-kit			snappy			zimg
dav1d			graphite2		libev			libvidstab		pcre			speex
eksctl			guile			libevent		libvorbis		pianobar		sqlite
ffmpeg			harfbuzz		libffi			libvpx			pixman			srt
fits			helm			libgcrypt		little-cms2		pkg-config		tcl-tk
flac			icu4c			libgpg-error		lzo			python@3.8		tesseract
fontconfig		jemalloc		libidn2			maven			python@3.9		theora
adoptopenjdk11                      adoptopenjdk8                       keepassxc                           postman                             visual-studio-code