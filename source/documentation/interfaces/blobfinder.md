---
layout: page
title: "BlobFinder"
date: 2012-06-21 23:56
comments: true
sharing: true
footer: true
---

The **blobfinder** interface provides access to devices that detect blobs in images.

Example
{% codeblock lang:ruby %}
require 'ruby-player'
Player::Client.connect "localhost" do |cl|
  bf = cl.blobfinder          # Subscribing 
  bf.set_color(channel: 0, 
    rmin: 1, rmax: 251, 
    gmin: 2, gmax: 252, 
    bmin: 3, bmax: 253)       # Set color boundaries for detection

  cl.read!                    # Read data from server

  bf.each do |b|
    puts b.state              # Put state for all detected blobs
  end
end
{% endcodeblock %}

### State

The BlobFinder class provides access to data state of blobfinder:

{% codeblock lang:ruby %}
  # by hash
  bf.state #=> { width: 0.0, height: 0.0, blobs: [] }
  # or through attributes
  bf.width #=> 0.0 
{% endcodeblock %}

State attributes:

* width - the image width in px.
* height - the image height in px.
* blobs - the array of blobs.
