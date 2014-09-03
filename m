From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] locks: Ability to test for flock presence on fd
Date: Wed, 3 Sep 2014 19:47:57 +0400
Message-ID: <5407382D.1020809@parallels.com>
References: <5405FBAE.5020303@parallels.com> <20140902184456.GC31793@fieldses.org> <54061562.4080306@parallels.com> <20140902194300.GE31793@fieldses.org> <20140902155351.79183446@tlielax.poochiereds.net> <540727E0.6030005@parallels.com> <20140903154434.GC22731@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140903154434.GC22731-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/03/2014 07:44 PM, J. Bruce Fields wrote:
...

>> Hope this explanation is more clear.
> 
> Thanks, I think I understand.
> 
> Remind me how you figure out which file descriptors point to the same
> file description (struct file)?

We do it with the help of kcmp() syscall:
https://github.com/cyrillos/linux-2.6/commit/951bc60c6a

Thanks,
Pavel
