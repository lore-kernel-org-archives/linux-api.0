From: Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: KDBUS breaks 'make installmandocs'
Date: Wed, 15 Jul 2015 11:04:20 -0700
Message-ID: <CA+r1Zhg3brrVjP3_-YhRxG0sjJY9tzK12BvWZ49G+qiQ-W9mkg@mail.gmail.com>
References: <20150712180846.GA32176@huvuddator>
	<20150714003925.GA23746@kroah.com>
	<20150714020040.GA17955@huvuddator>
	<CA+r1ZhjcOvHUcAMbhG4pqrxGMqAXV38Nf8jC_OS-ZxbsFrEj3g@mail.gmail.com>
	<CANq1E4QgzTFijvkfqa-sEYfVktJLEA3+oFh6Sm8NekLie6B9Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4QgzTFijvkfqa-sEYfVktJLEA3+oFh6Sm8NekLie6B9Ww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ulf Magnusson <ulfalizer.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 15, 2015 at 7:19 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> diff --git a/Documentation/kdbus/Makefile b/Documentation/kdbus/Makefile
> index af87641..8caffe5 100644
> --- a/Documentation/kdbus/Makefile
> +++ b/Documentation/kdbus/Makefile
> @@ -38,3 +38,7 @@ mandocs: $(MANFILES)
>  htmldocs: $(HTMLFILES)
>
>  clean-files := $(MANFILES) $(HTMLFILES)
> +
> +# we don't support other %docs targets right now
> +%docs:
> +       @true

Looks good, no errors with next-20150715. Thanks!

Jim
