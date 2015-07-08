From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC 8/8] kdbus: Ability to run kdbus test by executable binary
 name
Date: Wed, 8 Jul 2015 07:16:08 -0700
Message-ID: <20150708141608.GC10137@kroah.com>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
 <1436351110-5902-9-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436351110-5902-9-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Karol Lewandowski <k.lewandowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 08, 2015 at 12:25:10PM +0200, Paul Osmialowski wrote:
> With this applied, you can do following:
> 
> $ cp kdbus-test daemon
> $ cp kdbus-test send
> 
> Then run 'daemon' in one shell session:
> 
> $ ./daemon --bus test
> 
> ...and 'send' in another:
> 
> $ ./send --bus test
> 
> Useful for testing features introduced by previous patches.
> 
> Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
> ---
>  tools/testing/selftests/kdbus/kdbus-test.c | 5 +++++
>  1 file changed, 5 insertions(+)

Why not create symlinks automatically so this works without having to
manually run 'cp'?  But really, is spelling out the command line option
really a big issue?

thanks,

greg k-h
