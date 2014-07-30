From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Wed, 30 Jul 2014 15:37:58 +0100
Message-ID: <20140730153758.6431fafa@alan.etchedpixels.co.uk>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
	<20140725223550.3153f436@alan.etchedpixels.co.uk>
	<CALCETrXHNFYaQjksBJyN3O0HJpKw_D_tU7b4O23=nyJt9CPSLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <CALCETrXHNFYaQjksBJyN3O0HJpKw_D_tU7b4O23=nyJt9CPSLg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Theodore Ts'o <tytso@mit.edu>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-crypto@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> > We sort of have one. It's called capable(). Just needs extending to cover
> > anything else you care about, and probably all the numeric constants
> > replacing with textual names.
> >
> 
> Except that it's all backwards: these are things that default to *on*,
> and people might want them to turn off.  capable() is totally fscked
> if you want otherwise unprivileged users to carry capabilities around

The userspace API is, but capable() as a userspace API and capable() as
an in kernel check are only connected by history.

For the in kernel part you can either teach everyone another disjoint API
or we can have a single API in kernel for saying "is XYZ allowed".
