<?php

function cleanString(string $str)
{
    return preg_replace('/[^A-Za-z0-9-(-) ]/', '', trim($str));
}

function findPositionOfObjectByColumnAndValue($value, $column, $objects)
{
    return array_search($value, array_column($objects, $column));
}