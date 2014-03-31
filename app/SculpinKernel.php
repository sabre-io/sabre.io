<?php

date_default_timezone_set('UTC');

class SculpinKernel extends \Sculpin\Bundle\SculpinBundle\HttpKernel\AbstractKernel {

    protected function getAdditionalSculpinBundles() {

        return array();

    }
}
