From: Jann Horn <jann@thejh.net>
Subject: Re: [PATCH v7] fs: clear file privilege bits when mmap writing
Date: Fri, 22 Jan 2016 00:22:38 +0100
Message-ID: <20160121232238.GA4616@pc.thejh.net>
References: <20160111225750.GA4256@www.outflux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160111225750.GA4256@www.outflux.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, yalin wang <yalin.wang2010@gmail.com>, Willy Tarreau <w@1wt.eu>, Konstantin Khlebnikov <koct9i@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 11, 2016 at 02:57:50PM -0800, Kees Cook wrote:
> Normally, when a user can modify a file that has setuid or setgid bits,
> those bits are cleared when they are not the file owner or a member
> of the group. This is enforced when using write and truncate but not
> when writing to a shared mmap on the file. This could allow the file
> writer to gain privileges by changing a binary without losing the
> setuid/setgid/caps bits.
>=20
> Changing the bits requires holding inode->i_mutex, so it cannot be done
> during the page fault (due to mmap_sem being held during the fault). We
> could do this during vm_mmap_pgoff, but that would need coverage in
> mprotect as well, but to check for MAP_SHARED, we'd need to hold mmap_sem
> again. We could clear at open() time, but it's possible things are
> accidentally opening with O_RDWR and only reading. Better to clear on
> close and error failures (i.e. an improvement over now, which is not
> clearing at all).
>=20
> Instead, detect the need to clear the bits during the page fault, and
> actually remove the bits during final fput. Since the file was open for
> writing, it wouldn't have been possible to execute it yet (ETXTBSY).
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
[...]
> diff --git a/fs/file_table.c b/fs/file_table.c
> index ad17e05ebf95..ca11b86613cf 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -191,6 +191,21 @@ static void __fput(struct file *file)
> =20
>  	might_sleep();
> =20
> +	/*
> +	 * XXX: This is a delayed removal of privs (we've already been
> +	 * written to), since we must avoid mmap_sem. But a race shouldn't
> +	 * be possible since when open for writing, execve() will fail
> +	 * with ETXTBSY (via deny_write_access()). A remaining problem
> +	 * is that since we've already been written to, we must ignore the
> +	 * return value of file_remove_privs(), since we can't reject the
> +	 * writes of the past.
> +	 */
> +	if (unlikely(file->f_flags & O_REMOVEPRIV)) {
> +		mutex_lock(&inode->i_mutex);
> +		file_remove_privs(file);
> +		mutex_unlock(&inode->i_mutex);
> +	}
> +

If there is any other setuid file I can run, can't I just do this?

pid_t child =3D fork();
if (child =3D=3D 0) {
  /* fd will be 3 or so */
  int fd =3D open("setuid-file-with-bad-privs", O_WRONLY);
  char *ptr =3D mmap(..., fd, 0);
  memcpy(ptr, my_evil_code, sizeof(my_evil_code));
  /* su --bad-option just prints usage and exits, without touching
   * the fd - but since su has the last reference to the fd, __fput
   * will run with its privileges */
  execlp("su", "su", "--bad-option", NULL);
}
int status;
wait(&status);
execlp("setuid-file-with-bad-privs", "setuid-file-with-bad-privs", NULL);

I think that file_remove_privs() really needs to be changed to use f_cred
instead of current_cred(). That would also fix the known bypass where
you pass the fd to a setuid process as fd 1, causing the setuid process
to write more-or-less controlled data to a chosen offset, or similar
stuff (see
http://www.halfdog.net/Security/2015/SetgidDirectoryPrivilegeEscalation/).

Or was there already another patch that does this that I didn't see?

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWoWg+AAoJED4KNFJOeCOosz8QAJ1/kxFiY42HpAEHZDjsRofM
Vf/mq2mwNZ+rQ6cl/+4MdyzjViRkxtR8MUK5MhyhopuOJ+w+wydfCghfjVSaok0C
M9IhSSMOWgfgsiL/H9r54EjMCKxqQoU6f9ZlUV20Jt0PHXXoRBf/z4UMdhahZ841
eU67zfi25BmUlBk/rA7nAa07gliUfZ3owB9GzBRfF/sl7h+FRuGBRoMDnu1N6I3z
adxTCa0Iu2laks1lk2oXXvI6hPNp5IvEEir+qPfjJjyaT8BM+zWrKed0OPZk8PSv
Hclol+0xYGiCgpsy7/xWl0WSfSE2bZ3WgQQhhTPwDCYo+4G9+8QUJMZaM/+2HZ+s
psrUXeb+uxQ5ykM35KB1i5dGQ2pZnHUBWCB+uK7tCr1CdlgV5v5zGHaJvAhi1Q72
y1tmla7pq2FMdokjrbuPl0vjYKcfTOypSwpku4p8VYNEaBxK9node78JI9eiMjZ6
f0WYOZ5qbTnxjE9JbOKkJ908yMEUJ0z4Fh+PcYahKF6V7VUonZP+jfuNMWxphTcG
PhHZE01GkI5PoR+TG/IZ8tbz/3TWQswAQ9G9stXf4Ea/dBmCB5Io3roR6ni0jEar
8SJQKbexJbepupSyRSPW1Jq7LCo64oKDacU7vCpOTkMeRU95RKTQgsyuFhbfOAw9
SbfMyOhxcZH2fQ9Lhb2D
=97M3
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
