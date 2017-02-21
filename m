From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/3] fs,epoll: Add ability to call kcmp to find target files
Date: Tue, 21 Feb 2017 23:54:34 +0300
Message-ID: <20170221205434.GD27653@uranus>
References: <20170221165944.180372636@openvz.org>
 <39a65773-a58e-032b-1448-5e03bf78d763@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <39a65773-a58e-032b-1448-5e03bf78d763-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 21, 2017 at 03:32:21PM -0500, Jason Baron wrote:
> Hi,
> 
> Since an epoll fd can be added to another epoll fd, I'm wondering if you
> have enough data here to figure that out. The inode is the
> 'anon_inode_inode', so I'm wondering if that is sufficient to distinguish it
> from other anonymous inodes, or if an extra bit is required to indicate if
> the target file is in fact and epoll fd.

I think it should be ebough (together with sdev and pos). But will
look more closely tomorrow once I sit implementing criu support :)
(that's why it is early rfc, to gather comments)
