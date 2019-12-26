From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH] seccomp: Check flags on seccomp_notif is unset
Date: Thu, 26 Dec 2019 15:34:02 +0100
Message-ID: <57C06925-0CC6-4251-AD57-8FF1BC28F049@ubuntu.com>
References: <20191225214530.GA27780@ircssh-2.c.rugged-nimbus-611.internal> <20191226115245.usf7z5dkui7ndp4w@wittgenstein> <20191226143229.sbopynwut2hhsiwn@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191226143229.sbopynwut2hhsiwn@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Sargun Dhillon <sargun@sargun.me>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, tycho@tycho.ws, jannh@google.com, keescook@chromium.org
List-Id: linux-api@vger.kernel.org

On December 26, 2019 3:32:29 PM GMT+01:00, Aleksa Sarai <cyphar@cyphar.com> wrote:
>On 2019-12-26, Christian Brauner <christian.brauner@ubuntu.com> wrote:
>> On Wed, Dec 25, 2019 at 09:45:33PM +0000, Sargun Dhillon wrote:
>> > This patch is a small change in enforcement of the uapi for
>> > SECCOMP_IOCTL_NOTIF_RECV ioctl. Specificaly, the datastructure
>which is
>> > passed (seccomp_notif), has a flags member. Previously that could
>be
>> > set to a nonsense value, and we would ignore it. This ensures that
>> > no flags are set.
>> > 
>> > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
>> > Cc: Kees Cook <keescook@chromium.org>
>> 
>> I'm fine with this since we soon want to make use of the flag
>argument
>> when we add a flag to get a pidfd from the seccomp notifier on
>receive.
>> The major users I could identify already pass in seccomp_notif with
>all
>> fields set to 0. If we really break users we can always revert; this
>> seems very unlikely to me though.
>> 
>> One more question below, otherwise:
>> 
>> Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
>> 
>> > ---
>> >  kernel/seccomp.c | 7 +++++++
>> >  1 file changed, 7 insertions(+)
>> > 
>> > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> > index 12d2227e5786..455925557490 100644
>> > --- a/kernel/seccomp.c
>> > +++ b/kernel/seccomp.c
>> > @@ -1026,6 +1026,13 @@ static long seccomp_notify_recv(struct
>seccomp_filter *filter,
>> >  	struct seccomp_notif unotif;
>> >  	ssize_t ret;
>> >  
>> > +	if (copy_from_user(&unotif, buf, sizeof(unotif)))
>> > +		return -EFAULT;
>> > +
>> > +	/* flags is reserved right now, make sure it's unset */
>> > +	if (unotif.flags)
>> > +		return -EINVAL;
>> > +
>> 
>> Might it make sense to use
>> 
>> 	err = copy_struct_from_user(&unotif, sizeof(unotif), buf,
>sizeof(unotif));
>> 	if (err)
>> 		return err;
>> 
>> This way we check that the whole struct is 0 and report an error as
>soon
>> as one of the members is non-zero. That's more drastic but it'd
>ensure
>> that other fields can be used in the future for whatever purposes.
>> It would also let us get rid of the memset() below. 
>
>Given that this isn't an extensible struct, it would be simpler to just
>do
>check_zeroed_user() -- copy_struct_from_user() is overkill. That would
>also remove the need for any copy_from_user()s and the memset can be
>dropped by just doing
>
>  struct seccomp_notif unotif = {};
>
>> >  	memset(&unotif, 0, sizeof(unotif));
>> >  
>> >  	ret = down_interruptible(&filter->notif->request);
>> > -- 
>> > 2.20.1
>> > 

It is an extensible struct. That's why we have notifier size checking built in.
