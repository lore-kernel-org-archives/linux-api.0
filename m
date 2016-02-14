From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: getrichacl(1) man page review comments
Date: Sun, 14 Feb 2016 22:30:39 +0100
Message-ID: <56C0F1FF.3050003@gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77139.4080209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56B77139.4080209-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andreas,

Here's a few more comments on the current getrichacl(1) page
that I fetched from the git repo.

> .\"
> .\" RichACL Manual Pages
> .\"
> .\" Copyright (C) 2015,2016  Red Hat, Inc.
> .\" Written by Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> .\" This is free documentation; you can redistribute it and/or
> .\" modify it under the terms of the GNU General Public License as
> .\" published by the Free Software Foundation; either version 2 of
> .\" the License, or (at your option) any later version.
> .\"
> .\" The GNU General Public License's references to "object code"
> .\" and "executables" are to be interpreted as the output of any
> .\" document formatting or typesetting system, including
> .\" intermediate and printed output.
> .\"
> .\" This manual is distributed in the hope that it will be useful,
> .\" but WITHOUT ANY WARRANTY; without even the implied warranty of
> .\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> .\" GNU General Public License for more details.
> .\"
> .\" You should have received a copy of the GNU General Public
> .\" License along with this manual.  If not, see
> .\" <http://www.gnu.org/licenses/>.
> .\"
> .TH GETRICHACL 7 2015-09-01 "Linux" "Rich Access Control Lists"
>=20
> .SH NAME
> getrichacl \- Get Rich Access Control Lists
>=20
> .SH SYNOPSIS
> .B getrichacl
> .RI [ option "]... [" file ]...
>=20
> .SH DESCRIPTION
> For each file,
> .B getrichacl
> displays the file name and the file's Rich Access Control List (RichA=
CL).
>=20
> The output format of
> .B getrichacl
> is as follows:

Add a blank line here.

> .fam C
> .RS
> .nf
>  1:  file:
>  2:      flags:a
>  3:      owner:rwp-------------::mask
>  4:      group:r-p-------------::mask
>  5:      other:r---------------::mask
>  6:     owner@:rwp-------------::allow
>  7:   user:foo:r-p-------------::allow
>  8:     group@:r-p-------------::allow
>  9:  group:bar:r-p-------------::allow
> 10:  everyone@:r---------------::allow
> 11:
> .fi
> .RE
> .fam T
>=20
> Line 1 contains the file name, followed by a colon.
>=20
> Line 2 contains the ACL flags. This line is omitted if no flags are s=
et.
>=20
> Lines 3--5 indicate the owner, group, and other file masks, which are=
 only
> shown if the \fB\-\-raw\fR option is specified.
>=20
> Lines 6--10 indicate different ACL entries for the file owner
> .RB ( owner@ ),
> user \fIfoo\fR, the owning group
> .RB ( group@ ),
> group \fIbar\fR, and for everyone
> .RB ( everyone@ ).
>=20
> A blank line follows at the end.
>=20
> The default output format uses the single-letter forms of flags and
> permissions, identifiers of ACL entries are right justified, permissi=
ons are
> vertically aligned, and permissions which are always granted
> .RB ( read_attributes ", " read_acl ", " synchronize )
> are omitted. See the
> .BR richacl (7)
> manual page for the defined flags and permissions.
>=20
> By default,
> .B getrichacl
> displays the effective permissions remaining after applying the file =
masks to
> the ACL.  The file masks and underlying NFSv4 ACL can be displayed wi=
th the
> \fB\-\-raw\fR option.
>=20
> When
> .B getrichacl
> is used on a file that does not have a RichACL or on a filesystem tha=
t does not
> support RichACLs,
> .B getrichacl

Replace the previous line with "it".

> displays the access permissions defined by the traditional file permi=
ssion bits
> as a RichACL. When
> .B getrichacl
> is used on a file that has a POSIX ACL (see
> .BR acl (5)),
> it prints an error message.
>=20
> .SH OPTIONS
> .TP
> \fB\-\-long\fR, \fB\-l\fR
> Display access masks and flags in their long form.
> .TP
> \fB\-\-full\fR
> Also show permissions which are always implicitly allowed.
> .TP
> \fB\-\-raw\fR
> Show ACLs as stored on the file system, including the file masks. Imp=
lies
> \fB\-\-full\fR.
> .TP
> \fB\-\-unaligned\fR
> Do not align ACL entries or pad missing permissions with '-'.
> .TP
> \fB\-\-numeric-ids\fR
> Display numeric user and group IDs instead of names.
> .TP
> \fB\-\-access\fR [=3D\fIuser\fR[:\fIgroup\fR:...]}, \fB\-a\fR[\fIuser=
\fR[:\fIgroup\fR:...]}
> Instead of showing the ACL, show which permissions the user running t=
he command
> has for the specified file(s).  When \fIuser\fR is specified, show wh=
ich
> permissions the specified user has instead.  If \fIuser\fR is followe=
d by a
> colon and a (possibly empty) list of groups, assume that \fIuser\fR i=
s a member
> in the specified groups; otherwise,
> .BR getgrouplist (3)
> is used to determine the groups \fIuser\fR is a member in.

s/in/of/

> .TP
> \fB\-\-version\fR, \fB\-v\fR
> Display the version of
> .B getrichacl
> and exit.
> .TP
> \fB\-\-help\fR, \fB\-h\fR
> Display command-line usage help text.
>=20
> .SH AUTHOR
> Written by Andreas Gr=C3=BCnbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>.
>=20
> Please send your bug reports, suggested features and comments to the =
above address.
>=20
> .SH CONFORMING TO
> Rich Access Control Lists are Linux-specific.
>=20
> .SH SEE ALSO
> .BR richacl (7),
> .BR setrichacl (1)

Cheers,

Michael
