From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: CGroup Namespaces (v4)
Date: Mon, 16 Nov 2015 17:37:58 -0500
Message-ID: <20151116223758.GM18894@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <CAFLxGvzVmbZHrpaTmXUAK03hsnVPwEs3SJGNFNXfthh3NL8EDg@mail.gmail.com>
 <20151116204606.GA30681@mail.hallyn.com>
 <564A41AF.4040208@nod.at>
 <20151116205452.GA30975@mail.hallyn.com>
 <87y4dxh9b8.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87y4dxh9b8.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Eric.

On Mon, Nov 16, 2015 at 04:24:27PM -0600, Eric W. Biederman wrote:
> Does this allow mixing of cgroupfs and cgroupfs2?  That is can I: "mount
> -t cgroupfs" inside a container and "mount -t cgroupfs2" outside a
> container? and still have reasonable things happen?  I suspect the
> semantics of cgroups prevent this but I am interested to know what happens.

cgroup v1 and v2 are just separate hierarchies.  They can't nest each
other but co-existing and namespacing on their own is completely fine.
The caveat is that a given controller can be on only one hierarchy but
that's the same among v1 hierarchies too.

Thanks.

-- 
tejun
