From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: Re: [PATCHv8 1/6] fanotify: enable close-on-exec on events' fd when
 requested in fanotify_init()
Date: Sat, 27 Sep 2014 09:26:42 +0200
Message-ID: <542666B2.9080700@gmx.de>
References: <cover.1411562410.git.ydroneaud@opteya.com>	 <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>	 <542481B3.8070300@gmx.de> <1411721898.7778.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411721898.7778.18.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>, Lino Sanfilippo <LinoSanfilippo@gmx.de>
List-Id: linux-api@vger.kernel.org

Hello Andrew,

please, add the patch described in
https://lkml.org/lkml/2014/9/24/967
to the MM tree.

I have tested kernel 3.17.0-rc6 with and without the patch and it fixes=
=20
the described error.
As the patch is valid independent of the rest of the patch set, there i=
s=20
no reason to wait for the rest to be merged.

You may add
Reviewed by: Heinrich Schuchardt <xypron.glpk@gmx.de>

Best regards

Heinrich Schuchardt




On 26.09.2014 10:58, Yann Droneaud wrote:
> Hi,
>
> Le jeudi 25 septembre 2014 =C3=A0 22:57 +0200, Heinrich Schuchardt a =
=C3=A9crit :
>> On 24.09.2014 15:11, Yann Droneaud wrote:
>>> According to commit 80af258867648 ('fanotify: groups can specify
>>> their f_flags for new fd'), file descriptors created as part of
>>> file access notification events inherit flags from the
>>> event_f_flags argument passed to syscall fanotify_init(2).
>>>
>>> So while it is legal for userspace to call fanotify_init() with
>>> O_CLOEXEC as part of its second argument, O_CLOEXEC is currently
>>> silently ignored.
>>>
>>> Indeed event_f_flags are only given to dentry_open(), which only
>>> seems to care about O_ACCMODE and O_PATH in do_dentry_open(),
>>> O_DIRECT in open_check_o_direct() and O_LARGEFILE in
>>> generic_file_open().
>>
>> I tested on kernel 3.17.0-rc5. I passed O_CLOEXEC in event_f_flags.
>> When I called fcnt(event_metadata->fd, F_GETFD) it did not return
>> FD_CLOEXEC. So I can confirm your observation that O_CLOEXEC is not
>> working as expected.
>>
>> I found this definition
>> #define get_unused_fd() get_unused_fd_flags(0)
>>
>> So essentially when get_unused_fd() is called for a fanotify event
>> O_CLOEXEC is ignored.
>>
>> This is what your patch fixes.
>>
