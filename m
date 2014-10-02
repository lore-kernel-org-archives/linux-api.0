From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] fanotify: add a flag to allow setting O_CLOEXEC on event fd
Date: Thu, 2 Oct 2014 13:55:53 +0200
Message-ID: <CAKgNAkjEMEfgQurTFS5bUyC4U2WkuYBG72ARjNkn=W=OWPSEaw@mail.gmail.com>
References: <cover.1411562410.git.ydroneaud@opteya.com> <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>
 <542481B3.8070300@gmx.de> <1411721898.7778.18.camel@localhost.localdomain>
 <542666B2.9080700@gmx.de> <1411980555-10818-1-git-send-email-ydroneaud@opteya.com>
 <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org>
 <1412230855.28184.5.camel@localhost.localdomain> <1412236349-30035-1-git-send-email-ydroneaud@opteya.com>
 <542D1726.3040801@draigBrady.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <542D1726.3040801@draigBrady.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Andrew Morton <akpm@linux-foundation.org>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, stable@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Jan Kara <jack@suse.cz>, Lino Sanfilippo <LinoSanfilippo@gmx.de>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 2, 2014 at 11:13 AM, P=C3=A1draig Brady <P@draigbrady.com> =
wrote:
> On 10/02/2014 08:52 AM, Yann Droneaud wrote:
>> In order to not potentially break applications which were
>> requesting O_CLOEXEC on event file descriptors but which
>> actually need it to be not effective as the kernel currently
>> ignore the flag, so the file descriptor is inherited accross
>> exec regardless of O_CLOEXEC (please forgive me for the
>> wording), this patch introduces FAN_FD_CLOEXEC flag to
>> fanotify_init() so that application can request O_CLOEXEC
>> to be effective.
>> Newer application would use FAN_FD_CLOEXEC flag along
>> O_CLOEXEC to enable close on exec on newly created
>> file descriptor:
>>
>>   fd =3D fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK|FAN_FD_CLOEXEC,
>>                      O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);
>
> Ugh really?
> IMHO there should be widespread or at least known breakage with
> O_CLOEXEC before adding messiness like this.
> It seems surprising to me that apps that would depend on
> O_CLOEXEC being ineffective.
>
> please reconsider this one.

Agreed. The number of applications for which there are silent (not
*yet* observed) breakages because O_CLOEXEC is not working as expected
is likely rather larger than the set of applications that randomly
specify O_CLOEXEC and then somehow get broken as a result.

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
