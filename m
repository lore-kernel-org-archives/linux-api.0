From: Sergei Zviagintsev <sergei@s15v.net>
Subject: Re: [RFC 5/8] kdbus: use LSM hooks in kdbus code
Date: Thu, 9 Jul 2015 13:55:10 +0300
Message-ID: <20150709105510.GI25971@localhost.localdomain>
References: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
 <1436351110-5902-6-git-send-email-p.osmialowsk@samsung.com>
 <1436353775.2331.2.camel@samsung.com>
 <alpine.DEB.2.10.1507081411410.12441@AMDC1262.digital.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1507081411410.12441@AMDC1262.digital.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Lukasz Pawelczyk <l.pawelczyk@samsung.com>, Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Karol Lewandowski <k.lewandowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

Hi,

On Wed, Jul 08, 2015 at 02:12:03PM +0200, Paul Osmialowski wrote:
[...]
>  
> +	ret = security_kdbus_bus_alloc(b);
> +	if (ret) {
> +		goto exit_unref;
> +	}

checkpatch.pl will complain about this
