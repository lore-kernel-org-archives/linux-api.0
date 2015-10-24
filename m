From: =?UTF-8?Q?P=c3=a1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH v7 5/4] copy_file_range.2: New page documenting
 copy_file_range()
Date: Sat, 24 Oct 2015 13:02:21 +0100
Message-ID: <562B734D.50800@draigBrady.com>
References: <1445628736-13058-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1445628736-13058-6-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1445628736-13058-6-git-send-email-Anna.Schumaker@Netapp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Anna Schumaker <Anna.Schumaker@netapp.com>, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, viro@zeniv.linux.org.uk, clm@fb.com, darrick.wong@oracle.com, mtk.manpages@gmail.com, andros@netapp.com, hch@infradead.org
List-Id: linux-api@vger.kernel.org

On 23/10/15 20:32, Anna Schumaker wrote:
> +    len =3D stat.st_size;
> +
> +    fd_out =3D open(argv[2], O_CREAT|O_WRONLY|O_TRUNC, 0644);
> +    if (fd_out =3D=3D \-1) {
> +        perror("open (argv[2])");
> +        exit(EXIT_FAILURE);
> +    }
> +
> +    do {
> +        ret =3D copy_file_range(fd_in, NULL, fd_out, NULL, len, 0);
> +        if (ret =3D=3D \-1) {
> +            perror("copy_file_range");
> +            exit(EXIT_FAILURE);
> +        }
> +
> +        len \-=3D ret;
> +    } while (len > 0);

Is this an infinite loop if len decreases before the copy completes?
Perhaps this should be: while (len && ret);

Otherwise this set looks good.

I'm a bit worried about the sparse expansion and default reflinking
which might preclude cp(1) from using this call in most cases, but I wi=
ll
test and try to use it. coreutils has heuristics for determining if fil=
es
are remote, which we might use to restrict to that use case.

thanks,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
