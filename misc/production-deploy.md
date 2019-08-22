# Production deployment Notes

## SOLR

Helm chart used

image 6.6.6
storage class set aws-


* Setup intial collection and core

        $ rk get pods -n test-scholar 
        # git clone ir-scholar and cd into repo
        # Upload files to solr pod
        $ rk cp solr/config solr-0:/opt/solr/configset -n test-scholar

* Upload to zookeeper within contianer

        $ solr zk upconfig -n scholar -d configset
        $ solr create -c hydra-prod -n scholar -shards 2


## Scholar Administration set 




## Scholar Style

<div class="navbar-header">
        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#top-navbar-collapse" aria-expanded="false">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a id="logo" href="/" class="navbar-brand" style="
    width: 350px;
"><img src="https://www.colorado.edu/libraries/profiles/express/themes/ucb/images/cu-boulder-logo-text-white.svg" alt="Scholar @ University of Colorado Boulder">

</a>
<span class="navbar-brand" style="
    margin-top: 5px;
">Scholar</span>
      </div>






