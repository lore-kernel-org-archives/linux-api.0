From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [CFT][PATCH 08/10] sysfs: Add support for permanently empty
 directories to serve as mount points.
Date: Mon, 18 May 2015 06:14:39 -0700
Message-ID: <20150518131439.GA653@kroah.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
 <87siaxuvik.fsf@x220.int.ebiederm.org>
 <87fv6xtgr2.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fv6xtgr2.fsf_-_@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 15, 2015 at 09:09:53PM -0500, Eric W. Biederman wrote:
> 
> Add two functions sysfs_create_mount_point and sysfs_remove_mount_point
> that hang a permanently empty directory off of a kobject or remove a
> permanently emptpy directory hanging from a kobject.  Export these new
> functions so modular filesystems can use them.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/sysfs/dir.c        | 34 ++++++++++++++++++++++++++++++++++
>  include/linux/sysfs.h | 16 ++++++++++++++++
>  2 files changed, 50 insertions(+)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
