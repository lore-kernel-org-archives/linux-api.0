From: Kenton Varda <kenton@sandstorm.io>
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as
 bind mounts (take 2)
Date: Thu, 28 May 2015 14:07:43 -0700
Message-ID: <CAOP=4wiAA4SqvMn_rQJHOjg6M-75bi_G9Fx8ENgVnYdkT5WVQA@mail.gmail.com>
References: <87pp63jcca.fsf@x220.int.ebiederm.org> <87siaxuvik.fsf@x220.int.ebiederm.org>
 <87wq004im1.fsf@x220.int.ebiederm.org> <CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
 <20150528140839.GD28842@ubuntumail> <87lhg8pwvz.fsf@x220.int.ebiederm.org>
 <CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg@mail.gmail.com>
 <CAOP=4wid+N_80iyPpiVMN96_fuHZZRGtYQ6AOPn-HFBj2H6Vgg@mail.gmail.com>
 <87fv6gikfn.fsf@x220.int.ebiederm.org> <CAOP=4wieEaR_wESNyba7EKPAhi6kf+ujxhoMAFKVRozqWtXHvQ@mail.gmail.com>
 <55677EE4.2040903@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <55677EE4.2040903@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Serge Hallyn <serge.hallyn@ubuntu.com>, Seth Forshee <seth.forshee@canonical.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 28, 2015 at 1:47 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 28.05.2015 um 22:12 schrieb Kenton Varda:
>> We never mount sysfs in Sandstorm.
>
> sysfs is ABI and applications depend on it.
> Even glibc is using sysfs. Currently it has
> fallback paths but these may go away...

Off-topic, but Sandstorm isn't intended to provide a full Linux ABI.
It is intended to provide a secure sandbox that can run apps that have
been explicitly ported to Sandstorm. More background if you're interested:

https://github.com/sandstorm-io/sandstorm/wiki/Security-Practices-Overview#server-sandboxing
https://blog.sandstorm.io/news/2014-08-13-sandbox-security.html

-Kenton
