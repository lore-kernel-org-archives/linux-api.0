From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: getrichacl(1) man page review comments
Date: Sun, 7 Feb 2016 17:30:49 +0100
Message-ID: <56B77139.4080209@gmail.com>
References: <56B770B6.7040803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56B770B6.7040803-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Andreas,

Here, some comments on the getrichacl(1) page.

> .\"
> .\" Richacl Manual Pages
> .\"
> .\" Copyright (C) 2015  Red Hat, Inc.
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
> .RI [ OPTION "]... [" FILE ]...

In man-pages, at least, the convention is to use lower case for these
pieces (and thus through the remainder of the page), so:

> .RI [ option "]... [" file ]...

> .SH DESCRIPTION
> For each file, getrichacl displays the file name and Rich Access Cont=
rol List

=46or man-pages, at least, the convention is that the references to the
function/command name explained in the page are bold, do:

=2EBR getrichacl

> (richacl).

=46or what it's worth, I think it would be worthwhile to start with
a consistent abbreviation comment here (and use it throughout all of th=
e
man pages): "RichACL" (or "richACL"), rather than "richacl"; that seems
more consistent with the traditional abbreviation "ACL".

>=20
> By default, getrichacl displays the effective permissions remaining a=
fter

=2EBR getrichacl

> applying the file masks to the ACL.  The file masks and underlying NF=
Sv4 ACL
> can be displayed with the \-\-raw option.

Use
=2EBR \-\-raw

>=20
> The output format of getrichacl is as follows:

=2EBR getrichacl

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
> shown if the \-\-raw option is specified.
>=20
> Lines 6--10 indicate different ACL entries for the file owner
> .RB ( owner@ ),
> user foo, the owning group
> .RB ( group@ ),
> group bar, and for everyone

=2EIR bar ,

> .RB ( everyone@ ).
>=20
> A blank line follows at the end.
>=20
> By default, getrichacl displays the the single-letter forms of flags =
and

=2EBR getrichacl

s/the the/the/

> permissions, the identifiers of ACL entryies are right justified, the

s/entryies/entries/

> permissions are vertically aligned, and permissions which are always
> granted
> .RB ( read_attributes ", " read_acl ", " synchronize )
> are omitted. See the richacl(7) manual page for the defined flags and

Use
=2EBR richachl (7)
for page cross references.

> permissions.
>=20
> When getrichacl is used on a file that does not have a richacl or on =
a

=2EBR getrichacl

> filesystem that does not support richacls, getrichacl displays the ac=
cess

=2EBR getrichacl

> permissions defined by the traditional file permission bits as a rich=
acl. When
> getrichacl is used on a file that has a POSIX ACL, it prints an error=
 message.

=2EBR getrichacl

And then:

[...] has a POSIX ACL (see
=2EBR acl (7)), it prints [...]
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
> Show acls as stored on the file system including the file masks. Impl=
ies

s/axls/ACLs/

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
> Instead of the ACL, show which permissions the caller or a specified =
user has

"caller"? "the user running the command, "

> for file(s).  When a list of groups is given, this overrides the grou=
ps the

s/file(s)/specified file(s)/

> user is in.

The preceding text is not very clear.

> .TP
> \fB\-\-version\fR, \fB\-v\fR
> Display the version of getrichacl and exit.

=2EBR getrichacl

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
> .BR setrichacl (1),
> .BR richacl (7)

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
