<?php

function cleanString(?string $str):?string
{
    if( empty($str) )  return null;
    return preg_replace('/[^A-Za-z0-9-(-) ]/', '', trim($str));
}

function findPositionOfObjectByColumnAndValue($value, $column, $objects)
{
    return array_search($value, array_column($objects, $column));
}