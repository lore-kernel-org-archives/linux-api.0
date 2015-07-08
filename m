From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: Re: [RFC 8/8] kdbus: Ability to run kdbus test by executable binary
 name
Date: Wed, 08 Jul 2015 16:58:21 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1507081658000.23362@AMDC1262.digital.local>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
 <1436351110-5902-9-git-send-email-p.osmialowsk@samsung.com>
 <20150708141608.GC10137@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20150708141608.GC10137@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Karol Lewandowski <k.lewandowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

Hi Greg,

Thanks for your comments,

On Wed, 8 Jul 2015, Greg Kroah-Hartman wrote:

>
> Why not create symlinks automatically so this works without having to
> manually run 'cp'?

It can be anything on which one can apply security label. Symlinks can do.

> But really, is spelling out the command line option
> really a big issue?

Maybe. I couldn't think about any easier (and easy to present) use case 
that could explain the purpose of this change.

>
> thanks,
>
> greg k-h
>
