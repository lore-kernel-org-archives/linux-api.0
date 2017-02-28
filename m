From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [RFC 2/3] kcmp: Add KCMP_EPOLL_TFD mode to compare epoll target
 files
Date: Tue, 28 Feb 2017 09:53:06 +0300
Message-ID: <20170228065306.GH22938@uranus>
References: <20170221171255.023016858@openvz.org>
 <20170227224346.GA7101@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170227224346.GA7101@outlook.office365.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@virtuozzo.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linuxfoundation.org, xemul@virtuozzo.com, mtk.manpages@gmail.com, kir@openvz.org, luto@amacapital.net, jbaron@akamai.com, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 27, 2017 at 02:43:47PM -0800, Andrei Vagin wrote:
...
> > +
> > +		if (filp1 && filp_epoll) {
> > +			filp_tgt = get_epoll_tfile_raw_ptr(filp_epoll, slot.tfd, slot.toff);
> > +			if (IS_ERR(filp_tgt))
> > +				ret = PTR_ERR(filp_tgt);
> > +			else
> > +				ret = kcmp_ptr(filp1, filp_tgt, KCMP_EPOLL_TFD);
> 
> I think KCMP_FILE has to be used here ^^^^, because we compare files. We
> have to use the same function for all files to be able to sort them, don't we?

Yes. I already have v2 in my queue. Strictly speaking we can use separate
salt here but it will be waste of memory from userspace POV. I didn't send
v2 yet since I'm modifying criu still to test overall picture. Hopefully
will send today.
