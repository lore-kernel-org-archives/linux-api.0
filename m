From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/5] vfs: syscall: Add fsinfo() to query filesystem
 information
Date: Wed, 1 Aug 2018 12:28:49 -0400
Message-ID: <20180801162849.GA9187@thunk.org>
References: <153314002975.18964.1773855756473041897.stgit@warthog.procyon.org.uk>
 <153314004147.18964.11925284995448007945.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153314004147.18964.11925284995448007945.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Aug 01, 2018 at 05:14:01PM +0100, David Howells wrote:
> 
> Some attributes (such as the servers backing a network filesystem) can have
> multiple values.  These can be enumerated by setting params->Nth and
> params->Mth to 0, 1, ... until ENODATA is returned.

How does the caller know whether or not a particular attribute has
multiple values?  Is that a fundamental attribute of a particular
attribute?  (e.g., the documentation for each attribute must state
whether or not that attribute returns multiple attributes or not)

	       	    	      	      - Ted
