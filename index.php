<?php

use dflydev\markdown\MarkdownParser;

include __DIR__ . '/vendor/autoload.php';

$pathInfo = isset($_SERVER['PATH_INFO'])?$_SERVER['PATH_INFO']:'';

// Note, we must protect against people escaping the path with ..


$pagePath = __DIR__ . '/pages/';
$page = $pagePath . $pathInfo;

if (is_dir($page)) {
    $page = $page.'/index';
}

$page.='.md';

if (!file_exists($page)) {
    $page = $pagePath . '/error/404.md';
} 

$markdownParser = new MarkdownParser();

$output = $markdownParser->transformMarkdown(file_get_contents($page));

$loader = new Twig_Loader_Filesystem(__DIR__ . '/templates');
$twig = new Twig_Environment($loader);

echo $twig->render('global.twig', [

    'body' => $output

]);

