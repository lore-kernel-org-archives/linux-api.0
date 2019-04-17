From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 3/4] signal: support CLONE_PIDFD with pidfd_send_signal
Date: Wed, 17 Apr 2019 17:36:32 +0200
Message-ID: <B0F3DFB1-B9B5-478C-89BB-75CBC7719D3B@brauner.io>
References: <20190416170233.10208-1-christian@brauner.io> <20190416170233.10208-4-christian@brauner.io> <20190417140106.GG32622@redhat.com> <20190417141144.k2kmg7hd7pdpywyw@brauner.io> <20190417152055.GJ32622@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190417152055.GJ32622@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On April 17, 2019 5:20:55 PM GMT+02:00, Oleg Nesterov <oleg@redhat=2Ecom> w=
rote:
>On 04/17, Christian Brauner wrote:
>>
>> On Wed, Apr 17, 2019 at 04:01:06PM +0200, Oleg Nesterov wrote:
>> > On 04/16, Christian Brauner wrote:
>> > >
>> > > @@ -3581,12 +3588,12 @@ SYSCALL_DEFINE4(pidfd_send_signal, int,
>pidfd, int, sig,
>> > >  	if (flags)
>> > >  		return -EINVAL;
>> > >
>> > > -	f =3D fdget_raw(pidfd);
>> > > +	f =3D fdget(pidfd);
>> >
>> > could you explain this change?
>> >
>> > I am just curious, I don't understand why should we disallow O_PATH
>and how
>> > this connects to this patch=2E
>>
>> Sending a signal through a pidfd is considered to be on a par with a
>> "write" to that pidfd=2E
>
>OK, but how this connects to "support pidfds" ?
>
>> Additionally, we use the fops associated with the fd to detect
>whether
>> it is actually a pidfd or not=2E This is not possible with O_PATH since
>> f_ops will be set to dummy fops=2E
>
>indeed=2E=2E=2E I didn't know this, thanks!
>
>But this means that pidfd_send_signal() will return -EBADF with or
>without
>this change; pidfd_to_pid() will return -EBADF even if fdget_raw()
>suceeds,
>right?
>
>To clarify, I am not arguing=2E I am trying to understand why exactly do
>we
>need this s/fdget_raw/fdget/ change and, why it doesn't come as a
>separate
>patch=2E Can you add a note into the changelog?

I should split this into a separate patch indeed=2E
Let me do that for v2=2E

Christian
