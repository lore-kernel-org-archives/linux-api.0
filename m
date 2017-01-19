From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH v3 2/2] nsfs: Add an ioctl() to return owner UID of a userns
Date: Thu, 19 Jan 2017 15:12:42 +1300
Message-ID: <CAKgNAkjHhs3Xt-JMEe=O9mjWVQjh6+dZy41-x9YPJupxObBt5g@mail.gmail.com>
References: <69550fe9-5347-309c-b421-79c16a6300f6@gmail.com>
 <daac6f7d-bc1e-bd61-355b-e47cf93e2535@gmail.com> <20170117011948.GC10810@odin.tremily.us>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170117011948.GC10810@odin.tremily.us>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "W. Trevor King" <wking@tremily.us>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On 17 January 2017 at 14:19, W. Trevor King <wking@tremily.us> wrote:
> On Tue, Jan 17, 2017 at 02:03:29PM +1300, Michael Kerrisk (man-pages) wro=
te:
>> +     case NS_GET_OWNER_UID:
>> +             if (ns->ops->type !=3D CLONE_NEWUSER)
>> +                     return -EINVAL;
>> +             user_ns =3D container_of(ns, struct user_namespace, ns);
>> +             argp =3D (unsigned int __user *) arg;
>> +             uid =3D from_kuid_munged(current_user_ns(), user_ns->owner=
);
>> +             return put_user(uid, argp);
>> =E2=80=A6
>> +/* Get owner UID for a user namespace */
>> +#define NS_GET_OWNER_UID     _IO(NSIO, 0x4)
>
> The comment here should probably be:
>
>   Get owner UID (in the current user namespace) for a user namespace
>
> or some such, to convey that current_user_ns is being passed to
> from_kuid_munged.

Thanks, Trevor. I'll fix that. From a user-space perspective though
"in the current user namespace" should be "in the caller's user
namespace".

Cheers,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
