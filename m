From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC 3/8] lsm: kdbus security hooks
Date: Wed, 8 Jul 2015 07:14:04 -0700
Message-ID: <20150708141404.GB10137@kroah.com>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
 <1436351110-5902-4-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436351110-5902-4-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Karol Lewandowski <k.lewandowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 08, 2015 at 12:25:05PM +0200, Paul Osmialowski wrote:
> This is combination of the work by Karol Lewandowski and Paul Moore
> on LSM hooks for kdbus.
> 
> Originates from:
> 
> git://git.infradead.org/users/pcmoore/selinux (branch: working-kdbus)
> commit: 7050f206a79564886938d0edc4e1e9da5972c72d
> 
> https://github.com/lmctl/linux.git (branch: kdbus-lsm-v4.for-systemd-v212)
> commit: a9fe4c33b6e5ab25a243e0590df406aabb6add12

Again, horrid commit log entries :(
