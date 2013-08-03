<?php
if (extension_loaded('xhprof'))
{
    $profiler_namespace = 'lampdev';
    $xhprof_data 		= xhprof_disable();
    $xhprof_runs 		= new XHProfRuns_Default();
    $run_id      		= $xhprof_runs->save_run($xhprof_data, $profiler_namespace);
 
    // URL to the XHProf UI libraries - need to change host name and path if 
    // you add any custom vagrant setup
    $profiler_url = sprintf('http://localhost:8000' . '/xhprof_html/index.php?run=%s&source=%s', $run_id, $profiler_namespace);
    echo '<a href="'. $profiler_url .'" target="_blank">Profiler output</a>';
}
?>