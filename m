From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/5] create compat_writev()
Date: Fri, 16 Jan 2009 18:28:14 +0100
Message-ID: <200901161828.15349.arnd@arndb.de>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <1232124344-25892-3-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1232124344-25892-3-git-send-email-kraxel@redhat.com>
Content-Disposition: inline
Sender: linux-arch-owner@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, aarcange@redhat.com
List-Id: linux-api@vger.kernel.org

On Friday 16 January 2009, Gerd Hoffmann wrote:
> +asmlinkage ssize_t
> +compat_sys_writev(unsigned long fd, const struct compat_iovec __user=
 *vec, unsigned long vlen)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct file *file;
> +=A0=A0=A0=A0=A0=A0=A0ssize_t ret;
> +
> +=A0=A0=A0=A0=A0=A0=A0file =3D fget(fd);
> +=A0=A0=A0=A0=A0=A0=A0if (!file)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EBADF;
> +=A0=A0=A0=A0=A0=A0=A0ret =3D compat_writev(file, vec, vlen, &file->f=
_pos);
> + =A0 =A0 =A0 =A0fput(file);
> + =A0 =A0 =A0 =A0return ret;
> +}

This one still looks whitespace damaged, did you run the latest version
through checkpatch.pl?

	Arnd <><
