From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v8 2/2] samples: add an example of seccomp user trap
Date: Mon, 29 Oct 2018 20:05:07 -0600
Message-ID: <20181030020507.GA7343@cisco>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-3-tycho@tycho.ws>
 <20181029233100.GA24103@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181029233100.GA24103@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 29, 2018 at 11:31:00PM +0000, Serge E. Hallyn wrote:
> On Mon, Oct 29, 2018 at 04:40:31PM -0600, Tycho Andersen wrote:
> > +	if (req->data.nr != __NR_mount) {
> > +		fprintf(stderr, "huh? trapped something besides mknod? %d\n", req->data.nr);
> 
> 'besides mount' ?

Yes, thanks :)

Tycho
