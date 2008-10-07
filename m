From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Tue, 7 Oct 2008 14:52:19 -0400
Message-ID: <20081007185219.GD15929@mit.edu>
References: <20081004021251.GA29174@mit.edu> <48EA55AC.2060102@hp.com> <20081006210706.GB8139@mit.edu> <20081007101207.GA10406@infradead.org> <20081007130008.GA3503@shareable.org> <20081007130218.GA4316@infradead.org> <20081007132436.GC3503@shareable.org> <20081007132854.GA15953@infradead.org> <20081007154523.GA15929@mit.edu> <48EB87DE.4090607@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <48EB87DE.4090607-VXdhtT5mjnY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jim owens <jowens-VXdhtT5mjnY@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jamie Lokier <jamie-yetKDKU6eevNLxjTenLetw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Fasheh <mfasheh-IBi9RG/b67k@public.gmane.org>, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Right, thanks.  This time in proper English.  :-)

    * FIEMAP_EXTENT_ENCODED

    This extent does not consist of plain filesystem blocks but is
    encoded (e.g. encrypted or compressed).  Reading the data in this
    extent via I/O to the block device will have undefined results.

    Note that it is *always* undefined to try to update the data
    in-place by writing to the indicated location without the
    assistance of the filesystem, or to access the data using the
    information returned by the FIEMAP interface while the filesystem
    is mounted.  In other words, user applications may only read the
    extent data via I/O to the block device while the filesystem is
    unmounted, and then only if the FIEMAP_EXTENT_ENCODED flag is
    clear; user applications must not try reading or writing to the
    filesystem via the block device under any other circumstances.

    	       	       	     	    	      - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
