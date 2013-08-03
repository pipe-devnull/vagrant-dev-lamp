<h1> hi, this page should of been profiled</h1>
<p> Check fo a link below taking you nto the profiler output page</p>

<?php
// Some samples  to epview xhprof output

function test_for()
{
    for($i = 0; $i < 1000000; ++$i);
}

function test_while()
{
    $i = 0; while($i < 1000000) ++$i;
}


function test_sleep($x)
{
    sleep($x);
}


for ($i=0;$i<20;$i++)
{
	test_for();
	test_while();
}

test_sleep(1);
test_sleep(2);

?>
