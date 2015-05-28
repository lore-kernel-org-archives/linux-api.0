From: Richard Weinberger <richard@nod.at>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe
 as bind mounts (take 2)
Date: Thu, 28 May 2015 22:47:32 +0200
Message-ID: <55677EE4.2040903@nod.at>
References: <87pp63jcca.fsf@x220.int.ebiederm.org> <87siaxuvik.fsf@x220.int.ebiederm.org> <87wq004im1.fsf@x220.int.ebiederm.org> <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com> <20150528140839.GD28842@ubuntumail> <87lhg8pwvz.fsf@x220.int.ebiederm.org> <CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg@mail.gmail.com> <CAOP=4wid+N_80iyPpiVMN96_fuHZZRGtYQ6AOPn-HFBj2H6Vgg@mail.gmail.com> <87fv6gikfn.fsf@x220.int.ebiederm.org> <CAOP=4wieEaR_wESNyba7EKPAhi6kf+ujxhoMAFKVRozqWtXHvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOP=4wieEaR_wESNyba7EKPAhi6kf+ujxhoMAFKVRozqWtXHvQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kenton Varda <kenton@sandstorm.io>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Serge Hallyn <serge.hallyn@ubuntu.com>, Seth Forshee <seth.forshee@canonical.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

Am 28.05.2015 um 22:12 schrieb Kenton Varda:
> We never mount sysfs in Sandstorm.

sysfs is ABI and applications depend on it.
Even glibc is using sysfs. Currently it has
fallback paths but these may go away...

Thanks,
//richard
