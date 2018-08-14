From: Andrew Lutomirski <luto@kernel.org>
Subject: Re: Kernel lockdown patch & IPAddressAllow/IPAddressDeny systemd
 feature with Secure Boot
Date: Tue, 14 Aug 2018 07:14:00 -0700
Message-ID: <CAObL_7GOOQ01NPf4y1MqRJh4S=CYV8NPmEGTbkrTcjrfUKc5LA@mail.gmail.com>
References: <20180807212531.25161.63476@mailman01.phx2.fedoraproject.org> <CALeDE9ORLoyiUcf8Bmwr2rPyo7-3d8Fo54WuPGWtv4ByE_JG=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALeDE9ORLoyiUcf8Bmwr2rPyo7-3d8Fo54WuPGWtv4ByE_JG=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, ast@kernel.org, Laura Abbott <labbott@fedoraproject.org>, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
Cc: Kernel Fedora <kernel@lists.fedoraproject.org>
List-Id: linux-api@vger.kernel.org

[Removed Fedora devel list because it's subscriber-only]

> On Aug 8, 2018, at 12:29 AM, Peter Robinson <pbrobinson@gmail.com> wrote:
>
> Probably a good idea to cc: this to the kernel list :-)
>
> I suspect it's intentional but with the planned changes for iptables
> etc to be backed by bpf in the upstream kernel sometime in the future
> it's likely going to need to be reviewed.
>

I thought this got covered in review. I think this part of lockdown
needs to get reverted or fixed ASAP.

(I definitely brought up multiple issues with the bpf lockdown stuff.
It's clearly extremely broken right now in the "new kernel breaks
*current* Linux distro" sense.)

> Peter
>
>> On Tue, Aug 7, 2018 at 10:25 PM, Timoth=C3=A9e Ravier <tim@siosm.fr> wro=
te:
>> Booting Fedora with Secure Boot enabled will result in Lockdown being en=
abled at boot time. This will completly disable the BPF system call for all=
 users [1][2].
>>
>> Unfortunately, this breaks the IPAddressAllow & IPAddressDeny systemd fe=
ature [3][4][5].
>>
>> I don't have a solution for this, but as far as I understand, this will =
also prevent other BPF use-cases (for example: Cilium on Fedora CoreOS).
>>
>> [1] https://src.fedoraproject.org/rpms/kernel/blob/master/f/efi-lockdown=
.patch#_1525
>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/jforbes/linux.git/co=
mmit/?h=3Dlockdown&id=3D0eb0d0851747787f7182b3e9d0d38edb5925a678
>> [3] https://github.com/systemd/systemd/blob/master/src/core/bpf-firewall=
.c
>> [4] https://github.com/systemd/systemd/blob/master/NEWS#L1192
>> [5] https://www.freedesktop.org/software/systemd/man/systemd.resource-co=
ntrol.html#IPAddressAllow=3DADDRESS%5B/PREFIXLENGTH%5D%E2%80%A6
>> _______________________________________________
>> devel mailing list -- devel@lists.fedoraproject.org
>> To unsubscribe send an email to devel-leave@lists.fedoraproject.org
>> Fedora Code of Conduct: https://getfedora.org/code-of-conduct.html
>> List Guidelines: https://fedoraproject.org/wiki/Mailing_list_guidelines
>> List Archives: https://lists.fedoraproject.org/archives/list/devel@lists=
.fedoraproject.org/message/ZMEWJMQH6DDMV3AZ4IG7LOYMMIETCH42/
> _______________________________________________
> devel mailing list -- devel@lists.fedoraproject.org
> To unsubscribe send an email to devel-leave@lists.fedoraproject.org
> Fedora Code of Conduct: https://getfedora.org/code-of-conduct.html
> List Guidelines: https://fedoraproject.org/wiki/Mailing_list_guidelines
> List Archives: https://lists.fedoraproject.org/archives/list/devel@lists.=
fedoraproject.org/message/RUWDEDQHS5I47YBPEZVEKXNU2BAX2SLU/
