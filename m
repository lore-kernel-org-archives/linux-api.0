From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 2/2] nsfs: Add an ioctl() to return creator UID of a userns
Date: Thu, 22 Dec 2016 20:23:49 +1300
Message-ID: <87zijoh1fe.fsf@xmission.com>
References: <fdce894d-8385-b4b4-da3c-6282a7e4ecba@gmail.com>
        <46b85444-dc97-17a3-4445-439923936450@gmail.com>
        <20161221031315.GB20983@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161221031315.GB20983@outlook.office365.com> (Andrei Vagin's
        message of "Tue, 20 Dec 2016 19:13:16 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@virtuozzo.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

Andrei Vagin <avagin@virtuozzo.com> writes:

> On Mon, Dec 19, 2016 at 03:38:35PM +0100, Michael Kerrisk (man-pages) wrote:
>> @@ -174,6 +175,11 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
>>  		return open_related_ns(ns, ns->ops->get_parent);
>>  	case NS_GET_NSTYPE:
>>  		return ns->ops->type;
>> +	case NS_GET_CREATOR_UID:
>> +		if (ns->ops->type != CLONE_NEWUSER)
>> +			return -EINVAL;
>> +		user_ns = container_of(ns, struct user_namespace, ns);
>> +		return from_kuid_munged(current_user_ns(), user_ns->owner);
>
> uid_t is "unsigned int", ioctl() returns long, so it may be hard to
> distinguish user id-s from errors on x32.

Very good point.

> off-topic: What is about user_ns->group? I can't find where it is
> used...

Over design. I put it in because I thought it might be useful.  It turns
out it never was used so we can clean things up and remove it.  The
group has never been exposed to userspace so no one will care.

Eric
