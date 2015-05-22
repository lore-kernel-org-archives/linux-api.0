From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v2 2/3] fbcon: use the cursor blink interval provided by vt
Date: Fri, 22 May 2015 15:24:30 +0200
Message-ID: <2820529.TShzski8m6@wuerfel>
References: <alpine.DEB.2.11.1503261354550.2411@local> <3661627.JqpS87pBks@wuerfel> <20150522114957.GF16507@ulmo>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150522114957.GF16507@ulmo>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Daniel Stone <daniel-rLtY4a/8tF1rovVCs/uTlw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Friday 22 May 2015 13:49:58 Thierry Reding wrote:
> On Fri, May 22, 2015 at 12:33:42PM +0200, Arnd Bergmann wrote:
> > On Friday 22 May 2015 12:00:03 Thierry Reding wrote:
> > > 
> > > > Remember, if I have to hand-edit, or do something special with your
> > > > patch, I will not do it, you need to do it correctly to make
> > > > maintainer's lives easier, not harder, given that maintainers are the
> > > > limited resouce, not developers.
> > > 
> > > I understand. I'll make a mental note to never send you patches as
> > > attachment again.
> > > 
> > 
> > Better make that a general rule. My workflow is different from Greg's
> > but also doesn't cope well with attachments. A lot of people in turn
> > have problems quoting from an attachment when replying to the patch,
> > which happens to work for me.
> 
> Okay. Any hints on how to simplify sending out such patches with the
> same list of recipients? I find it very annoying to have to manually
> copy each recipient into the git send-email command-line, but I don't
> know of a better way to do it. Replying to an email from the MUA will
> at least do that automatically.

You can have a line starting with 8<------ (the scissors  symbol) after
your reply, and then paste the patch below.

I usually use 'git show --format=email | xclip' to copy the patch into
the X clipboard and paste it into the email window from there.

	Arnd
