From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
Date: Thu, 23 Oct 2014 12:14:57 +0400
Message-ID: <20141023081457.GE16267@moon>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
 <2940943.qiYEMaLEXx@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2940943.qiYEMaLEXx@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org, shuahkh@osg.samsung.com, linux-api@vger.kernel.org, Andrew Morton <akpm@osdl.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 23, 2014 at 09:49:14AM +0200, Arnd Bergmann wrote:
> On Thursday 23 October 2014 16:07:12 Michael Ellerman wrote:
> > --- a/include/linux/kcmp.h
> > +++ b/include/linux/kcmp.h
> > @@ -1,17 +1,6 @@
> >  #ifndef _LINUX_KCMP_H
> >  #define _LINUX_KCMP_H
> >  
> > -/* Comparison type */
> > -enum kcmp_type {
> > -       KCMP_FILE,
> > -       KCMP_VM,
> > -       KCMP_FILES,
> > -       KCMP_FS,
> > -       KCMP_SIGHAND,
> > -       KCMP_IO,
> > -       KCMP_SYSVSEM,
> > -
> > -       KCMP_TYPES,
> > -};
> > +#include <uapi/linux/kcmp.h>
> >  
> >  #endif /* _LINUX_KCMP_H */
> > 
> 
> If the file is empty except for the uapi include, I think it's better to
> delete it completely. The include path logic should ensure we pick the
> other one up.

Good point, somehow managed to miss this.
