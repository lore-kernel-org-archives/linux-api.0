From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH V38 19/29] Lock down module params that specify hardware
 parameters (eg. ioport)
Date: Fri, 9 Aug 2019 02:33:37 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1908090232530.31143@namei.org>
References: <20190808000721.124691-1-matthewgarrett@google.com> <20190808000721.124691-20-matthewgarrett@google.com> <20190808111246.GA29211@linux-8ccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190808111246.GA29211@linux-8ccs>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@kernel.org>
Cc: Matthew Garrett <matthewgarrett@google.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@google.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Thu, 8 Aug 2019, Jessica Yu wrote:

> > +#ifdef CONFIG_MODULES
> > +#define mod_name(mod) ((mod)->name)
> > +#else
> > +#define mod_name(mod) "unknown"
> > +#endif
> > +
> 
> Hm, I don't think mod_name is used anywhere?
> 
> But other than that:
> 
> Acked-by: Jessica Yu <jeyu@kernel.org>
> 

Matthew: no need to respin the patchset just for this. 

-- 
James Morris
<jmorris@namei.org>
