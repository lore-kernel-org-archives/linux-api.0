From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: setrichacl(1) man page review comments
Date: Sun, 7 Feb 2016 17:31:43 +0100
Message-ID: <56B7716F.6060404@gmail.com>
References: <56B770B6.7040803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56B770B6.7040803-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Andreas,

Here, some comments on the setrichacl(1) page.

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
> .TH SETRICHACL 7 2015-09-01 "Linux" "Rich Access Control Lists"
>=20
> .SH NAME
> setrichacl \- Set Rich Access Control Lists
>=20
> .SH SYNOPSIS
> .B setrichacl
> .RI [ OPTION "]... [" FILE ]...

In man-pages, at least, the convention is to use lower case for these
pieces (and thus through the remainder of the page), so:

> .RI [ option "]... [" file ]...

>=20
> .SH DESCRIPTION
> The setrichacl utility sets or modifies Rich Access Control Lists (ri=
chacls) of

=2EBR setrichacl

> files and directories.
>=20
> The
> .B \-m
> and
> .B \-s
> options expect an ACL or parts of an ACL on the command line. The
> .B \-M
> and
> .B \-S
> options read an ACL or parts of an ACL from a file. In either case, t=
he entry
> format is described in section
> .I TEXT FORM
> of the richacl(7) manual page. The single-letter or long forms of fla=
gs and

Use
=2EBR richachl (7)
for page cross references.

> permissions can be mixed arbitrarily. Multiple entries are separated =
by
> whitespace, newlines or commas.
>=20
> Note that the order of ACL entries matters, and that changing the ord=
er may
> grant different permissions.
>=20
> The use of
> .B deny
> entries is discouraged. If
> .B deny
> entries are used, they should be placed ahead of
> .B allow
> entries for improved interoperability with Windows where possible.
>=20
> When the file masks are not specified, they are computed automaticall=
y.
>=20
> When the ACL to be set is simple enough that the traditional file per=
mission
> bits can express the same permissions, setrichacl instead only sets t=
he file

=2EBR setrichacl

> permission bits. Minor differences that do not have an influence on t=
he
> permissions granted by the acl are not preserved.  When setrichacl's

s/acl/ACL/

=2EBR setrichacl 's

> counterpart utility, getrichacl, is used on a file or directory that =
does not

=2EBR getrichacl ,

> have a richacl, it displays the access permissions defined by the fil=
e
> permission bits as a richacl.
>=20
> .SS Permissions
>=20
> Setting ACLs or changing the file permission bits is allowed to the f=
ile owner,
> to processes which have the write_acl permission, and to processes wh=
ich have

=2EB write_acl

> the CAP_FOWNER capability.

=2EB CAP_FOWNER

>=20
> .SH OPTIONS
> .TP
> \-\-\fBmodify\fR \fIacl\fR, \fB\-m\fR \fIacl\fR
> Modify the ACL of \fIFILE\fR by replacing existing entries with the e=
ntries in
> \fIacl\fR, and adding all new entries. When the permissions of an ent=
ry are
> empty, remove the entry.
> .TP
> \fB\-\-modify\-file\fR \fIacl_file\fR, \fB\-M\fR \fIacl_file\fR
> Identical to \-\-modify, but read the ACL from \fIacl_file\fR instead=
=2E If the

=2EB \-\-modify

> file is \(lq\-\(rq, read from standard input.
> .TP
> \fB\-\-set\fR \fIacl\fR, \fB\-s\fR \fIacl\fR
> Set the ACL of \fIFILE\fR to \fIacl\fR. Any previous ACL is replaced.
> ACL entries are separated by whitespace, newlines, or commas.
> .TP
> \fB\-\-set\-file\fR \fIacl_file\fR, \fB\-S\fR \fIacl_file\fR
> Identical to \-\-set, but read the ACL from \fIacl_file\fR instead. I=
f the

=2EBR \-\-set ,

> file is \(lq\-\(rq, read from standard input.
> .TP
> \fB\-\-remove\fR, \fB\-b\fR
> Remove all extended permissions and revert to the file permission bit=
s only.
> .TP
> \fB\-\-version\fR, \fB\-v\fR
> Display the version of setrichacl and exit.

=2EBR setrichacl

> .TP
> \fB\-\-help\fR, \fB\-h\fR
> Display command-line usage help text.
>=20
> .\" .SH EXAMPLES

Yes please!

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
> .BR getrichacl (1),
> .BR richacl (7)

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
