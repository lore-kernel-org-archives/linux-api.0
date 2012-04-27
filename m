From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Fri, 27 Apr 2012 11:10:57 -0400
Message-ID: <20120427151057.GA16580@fieldses.org>
References: <20120427010610.GE9541@dastard>
 <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
 <4111.1335519545@redhat.com>
 <20120427131306.GG9541@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120427131306.GG9541@dastard>
Sender: linux-ext4-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 27, 2012 at 11:13:06PM +1000, Dave Chinner wrote:
> Right now it is, but there's ben patches in the past to introduce
> project quotas to ext4. That didn't go far because it was done in a
> way that was semantically different to XFS (for no reason that I
> could understand) and nobody wanted two different sets of semantics
> for the "same" feature.  The most common use of project quotas is to
> implement sub-tree quotas,

(Though it's also useful as a way to do safe subtree NFS exports).

--b.

> which is probably of more interest to
> btrfs folks as it is an exact match for per-subvolume quotas.
> 
> So, yes, I do see it as something generically useful - it's a
> feature that a lot of people use XFS specifically for....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
