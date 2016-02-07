From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: richacl(7) man page review comments
Date: Sun, 7 Feb 2016 17:35:46 +0100
Message-ID: <56B77262.7090107@gmail.com>
References: <56B770B6.7040803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56B770B6.7040803-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andreas,

I'll probably have quite a few more comments on this page as I get to
understand RichACLs better. Here's some comments from an initial
reading.

So, an initial comment. It seems to me to that this page (but
not setrichacl(1) and getrichacl(1)) should ultimately land in
man-pages (just like acl(7)), since we're talking about a kernel
feature. Make sense?

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
> .de URL
> \\$2 \(laURL: \\$1 \(ra\\$3
> ..
> .if \n[.g] .mso www.tmac
> .TH RICHACL 7 2015-09-01 "Linux" "Rich Access Control Lists"
> .SH NAME
> richacl \- Rich Access Control Lists
> .SH DESCRIPTION
> Rich Access Control Lists (richacls) are an extension of the POSIX fi=
le

=46or what it's worth, I think it would be worthwhile to start with
a consistent abbreviation comment here (and use it throughout all of th=
e
man pages): "RichACL" (or "richACL"), rather than "richacl"; that seems
more consistent with the traditional abbreviation "ACL".

> permission model to support

Make this:

permission mode (see
=2EBR acl (7))
to support

> .URL https://tools.ietf.org/rfc/rfc5661.txt "NFSv4 Access Control Lis=
ts"
> on local and remote-mounted filesystems.
>=20
> Richacls support file masks which allow to apply a file mode to an ex=
isting

s/which allow to apply/which can be used to apply/

> NFSv4 ACL without destructive side effects: the file mode determines =
the values
> of the file masks; the file masks restrict the permissions granted by=
 the NFSv4
> ACL.  When a less restrictive file mode is applied later, the file ma=
sks become
> less restrictive, and more of the original permissions can become eff=
ective.
>=20
> A richacl can always be translated into an equivalent NFSv4 ACL which=
 grants
> the same permissions.
>=20
> Richacls can be enabled on supported filesystems. This disables POSIX=
 Access
> Control Lists; the two ACL models will not coexist on the same filesy=
stem.

s/will not/can not/ ?

>=20
> When used on a filesystem that does not support richacls, the getrich=
acl and

Use
=2EBR getrichacl (1)
for cross-references.

> setrichacl utilities will operate on the file permission bits instead=
:
> getrichacl will display the file permission bits as a richacl; when a=
 richacl

Use
=2EBR getrichacl (1)
for cross-references.

> is set with setrichacl which can be represented exactly by the file p=
ermission

Use
=2EBR setrichacl (1)
for cross-references.

> bits, setrichacl will set the file permission bits instead.

Use
=2EBR setrichacl (1)
for cross-references.

Here, I think it would be helpful to add a sentence:

"An attempt to set a richacl that cannot be represented exactly by the
file permission bits results in an error."

(If that sentence is correct, of course.)

>=20
> .SH STRUCTURE OF RICHACLS

=46or all of the "nonstandard" (see man-pages(7)) ".SH" sections here, =
I'd
be inclined to switch to using ".SS" subsections. There are downsides t=
o
multiple nonstandard section headings (e.g., automated TOCs for
Section headings become clumsy and long), and I don't think your use of
=2ESH vs .SS really helps much to structure the information in this pag=
e.

>=20
> Richacls consist of a number of ACL entries, three file masks, and so=
me flags.

s/some flags./some flags specifying attributes of the ACL as whole (by
contrast with the per-ACL-entry flags described below)./

> Each of the ACL entries allows or denies some permissions to a partic=
ular user,
> group, or special entity. Each acl entry consists of:

s/acl//

> .IP \(bu 4
> The user (with prefix

s/The user/A tag which specifies the user/

(Is "tag" the right word? In any case, what would helpful to have here
is the generic term for this component of the ACL.)

> .B user:
> or
> .BR u: ),
> group (with prefix
> .B group:
> or
> .BR g: ),
> or special identifier the entry applies to. Special
> identifiers can be the file owner
> .RB ( owner@ ),
> the owning group
> .RB ( group@ ),
> or everyone
> .RB ( everyone@ ).
> .IP \(bu
> A set of permissions the entry allows or denies.
> .IP \(bu
> A set of flags that indicate whether the user or group identifier is =
mapped or
> unmapped, and whether the entry has been and can be inherited.
> .IP \(bu 4
> A field indicating whether the entry allows or denies access.
> .PP
> The owner, group, and other file masks further control which permissi=
ons the
> ACL grants, subject to the
> .B masked
> .RB ( m )
> and
> .B write_through
> .RB ( w )
> ACL flags.
>=20
> Note that entries with the identifier
> .B everyone@
> apply to all processes, whereas the \(lqother\(rq file permissions an=
d
> \(lqother\(rq entries in POSIX ACLs apply to all processes which are =
not the
> owner, are not in the owning group, and do not match a user or group =
mentioned
> in the acl.

s/acl/ACL/

> Richacls do not have separate \(lqaccess\(rq ACLs that define the acc=
ess
> permissions and \(lqdefault\(rq ACLs that define the inheritable perm=
issions as
> POSIX ACLs.

I'd restructure the preceding sentence as:

"Unlike POSIX ACLs, richacls do not.... that define the inheritable
permissions."

> Instead, whether an ACL entry is effective during access checks
> and/or inheritable is determined by the ACL entry flags.
>=20
> .SS ACL Flags

I'd use lower case in the above for all words except the first.
(That's the convention in man-pages.)

>=20
> The following flags on ACLs are defined:
>=20
> .RS 4
> .HP 4

s/4/8/ in the preceding two lines. I think more indentation would make
this (and the similar lists below) more readable.

> .B masked
> .RB ( m ):

I'd write each of these list entries starting here, and below, in the
form:

=2EBR masked "\ (" m ):

This form is a little easier to read in the source, and
it forces just a single space before the "(", which looks
a little better, I find.

> When set, the file masks define upper limits on the permissions the A=
CL may
> grant.
> .HP
> .B write_through
> .RB ( w ):
> When this flag and the masked flag are both set, the owner and other =
file masks

=2EB masked

> define the actual permissions granted to the file owner and to others=
 instead
> of an upper limit.
> .HP
> .B auto_inherit
> .RB ( a ):
> Automatic Inheritance is enabled for the file the ACL is
> attached to. See
> .IR "Automatic Inheritance" .
> .HP
> .B protected
> .RB ( p ):
> The ACL is protected from modification by Automatic
> Inheritance.
> .HP
> .B defaulted
> .RB ( d ):
> The ACL has been assigned by default. Automatic Inheritance should co=
mpletely
> replace the ACL.
> .RE
>=20
> .SS ACL Entry Flags
>=20
> The following flags on ACL entries are defined:
>=20
> .RS 4
> .HP 4

s/4/8/ in the preceding two lines.

> .B file_inherit
> .RB ( f ):
> The entry is inheritable for files.
> .HP
> .B dir_inherit
> .RB ( d ):
> The entry is inheritable for directories.
> .HP
> .B no_propagate
> .RB ( n ):
> Inheritance stops at the next subdirectory level.
> .HP
> .B inherit_only
> .RB ( i ):
> The entry defines inheritable permissions only and is ignored for acc=
ess
> checking.
> .HP
> .B inherited
> .RB ( a ):
> The entry has been automatically inherited from the parent directory;=
 the
> ACL's auto_inherit

Use
=2EB auto_inherit

> .RB ( a )
> flag should be on.
> .HP
> .B unmapped
> .RB ( u ):
> The user or group identifier is a textual string and has no mapping t=
o a
> numeric user or group identifier.

So here, I think there should be a sentence that explains how a meaning
is attached to the strings? Is this for NFS, for Windows, for something
else?

> .RE
>=20
> .SS Permissions
>=20
> The following permissions are defined for richacl entries and for the=
 three
> file masks:
>=20
> .RS 4
> .HP 4

s/4/8/ in the preceding two lines.

> .B read_data
> /
> .B list_directory
> .RB ( r ):

Replace the preceding four lines by

=2EBR read_data / list_directory "\ (" r )

and do similar for the next two list entried below.
Note that "\ (" will force just a singlke space before the "(".

> Read the data of a file.
> List the contents of a directory.

In the above list entry, and the next two, I find the layout ("xxx/yyy =
(z)")
confusing. A closer reading indicates that in each case, the "xxx"
applies for files and he "yyy" is for directories. But I think the text
could make this point a little easier to grasp. In each of these three
list entries this could be done something lke the following:

"For a file: read the data of the file. For a directory: list the
contents of the directory."

By the way, can the terms "read_data" and "list_directory" be used
interchangeably? That is, can you employ (say) "read_data" when setting
an ACL entry for a directory? (I'm assuming the answer is "yes".)
If the terms are just interchangeable synonyms, perhas it's worth
making that point explicitly in the text.

> .HP
> .B write_data
> /
> .B add_file
> .RB ( w ):
> Modify the data of a file. Add a new file in a directory.

See above comment re file/directory.

> .HP
> .B append_data
> /
> .B add_subdirectory
> .RB ( p ):
> Open a file in append mode. Create a subdirectory in a directory.

So, in other words, if append mode is denied, then the file can be
opened for writing (contingent on write permission  being granted), but
can't be opened with O_APPEND? Is that correct? This point needs to be
made clearer.

> .HP
> .B execute
> .RB ( x ):
> Execute a file. Traverse / search a directory.

See above comment re file/directory.

> .HP
> .B delete_child
> .RB ( d ):
> Delete a file or directory within a directory.
> .HP
> .B delete
> .RB ( D ):
> Delete the file or directory.
> .HP
> .B read_attributes
> .RB ( a ):
> Read basic attributes of a file or directory.

What are "attributes" in this context? Does this mean stat(2)? Make thi=
s
explicit.

> This permission is always implicitly granted.
> .HP
> .B write_attributes
> .RB ( A ):
> Change the times associated with a file or directory to an arbitrary =
value.
> This permission is always implicitly granted to the file owner.
> .HP
> .B read_acl
> .RB ( c ):
> Read the ACL of a file or directory. This permission is always
> implicitly granted.
> .HP
> .B write_acl
> .RB ( C ):
> Change the ACL or file mode of a file or directory.
> .HP
> .B write_owner
> .RB ( o ):
> Take ownership of a file or directory.  Change the owning group of a =
file or
> directory to a group of which the calling process is a member.
> .HP
> .B read_named_attrs
> .RB ( R ),
> .B write_named_attrs
> .RB ( W ),
> .B synchronize
> .RB ( S ),
> .B write_retention
> .RB ( e ),
> .B write_retention_hold
> .RB ( E ):
> These permissions can be stored, but do not have a local meaning.

So, I thenk that a sentence here should explain why these permissions
exist. Is if for future extension, because they are meaningful in NFS,
or something else?

> .RE
>=20
> .SH TEXT FORM
>=20
> The common textual representation of richacl consists of the colon se=
parated

s/richacl/richacls/ (or, "RichACLs"/"richACLs")

s/colon separated/colon-separated/

> fields of the the acl flags, file masks, and acl entries in the follo=
wing

s/acl/ACL/ (*2)

> format:
> .TP
> \fBflags:\fR\fIacl_flags\fR
> The ACL flags.
> .TP
> \fBowner:\fR\fIperm\fR\fB::mask\fR, \fBgroup:\fR\fIperm\fR\fB::mask\f=
R, \fBother:\fR\fIperm\fR\fB::mask\fR
> The file masks and their permissions.
> .TP
> \fIwho\fR\fB:\fR\fIperm\fR\fB:\fR\fIflags\fR\fB:allow\fR, \fIwho\fR\f=
B:\fR\fIperm\fR\fB:\fR\fIflags\fR\fB:deny\fR
> For each ACL entry, who the entry applies to, the permissions of the =
entry, the
> entry flags, and whether the entry allows or denies permissions.  The=
 who field has

s/who/\\fIwho\\fP/

> no prefix for special identifiers, a
> .B user:
> or
> .B u:
> prefix for regular users, and a
> .B group:
> or
> .B g:
> prefix for regular groups.
> .PP
> The entries are comma, whitespace or newline separated.

s/whitespace/whitespace,/

>=20
> Flags and permissions have single-letter as well as long forms as lis=
ted under

s/forms/forms,/

> .IR "ACL Flags" ,
> .IR "ACL Entry Flags" ,
> and
> .IR Permissions .

If you follow my suggestion about capitalization in the ".SS" entries,
you'll need to change the capitalization in the above phrases.

> When the single-letter forms are used, the flags or permissions are
> concatenated. When the long forms are used, the flags or permissions =
are
> separated by slashes.  To align permissions or flags vertically, dash=
es can be
> use for padding.

s/use/used/

>=20
> .SH SETTING AND MODIFYING FILE PERMISSIONS
> The access permissions for a file can either be set by assigning an a=
ccess
> control list (setrichacl) or by changing the file mode permission bit=
s (chmod).

Use
=2ERB ( setrichacl (1))
for cross-reference.

Use
=2ERB ( chmod (1)).

> In addition, a file can inherit an ACL from its parent
> directory at create time; the inherited ACL is then further

s/create/creation/

> restricted by the creating system call's mode parameter (see the crea=
t(2)
> manual page).

creat(2) is pretty much history. I suggest writing

(as given to
=2EBR open (2),
=2EBR mkdir (2),
and similar).

And here, I think we need a statement about whether the process umask
has an effect or not...

>=20
> .SS Assigning An Access Control List
> When assigning an ACL to a file, unless explicitly specified, the own=
er, group,
> and other file masks will be computed from the ACL entries as describ=
ed in
> section
> .IR "COMPUTING THE MAXIMUM FILE MASKS" .
> The owner, group, and other file mode permission bits are then each s=
et from
> the owner, group, and other file mask as follows:
> .IP \(bu 4
> If the file mask includes the
> .B r
> permission, the read
> file mode permission bit will be set.
> .IP \(bu
> If the file mask includes the
> .B w
> or
> .B p
> permission, the write file mode permission bit will be set.
> .IP \(bu
> If the file mask includes the
> .B x
> permission, the execute file mode permission bit will be set.
> .PP
> If the ACL can be represented exactly by the file mode
> permission bits, the file permission bits are set to match the access=
 control
> list and the ACL is not stored.  (When the reverse happens and

s/and/and the/

> ACL of a file is requested which doesn't have an explicit
> ACL, the file mode permission bits are converted into an
> equivalent richacl.)
>=20
> .SS Changing The File Mode Permission Bits

I'd use lower case in the above for all words except the first

> When changing the file mode permission bits with chmod(2), the owner,=
 group,

=2EBR chmod (2)

> and other file permission bits are set to the permission bits in the =
new mode,
> and the file masks each are set based on the new mode bits as follows=
:
> .IP \(bu 4
> If the read bit in a set of permissions is set, the
> .B r
> permission in the corresponding file mask will be set.
> .IP \(bu
> If the write bit in a set of permissions is set, the
> .B w
> and
> .B p
> permissions in the corresponding file mask will be set.
> .IP \(bu
> If the execute bit in a set of permissions is set, the
> .B x
> permission in the corresponding file mask will be set.
> .PP
> In addition, the
> .B masked
> and
> .B write_through
> ACL flags are set. This has the
> effect of limiting the permissions granted by the ACL to the file mod=
e
> permission bits; in addition, the owner is granted the owner mode bit=
s and
> others are granted the other mode bits. If the
> .B auto_inherit
> flag is set, the
> .B protected
> flag is also set to prevent the Automatic Inheritance algorithm from =
modifying
> the ACL.
>=20
> .SS Permissions At File Create Time

s/File Create/file-creation/

I'd use lower case in the above for all words except the first

> When a directory has inheritable ACL entries, the following
> happens when a file or directory is created inside that directory:
> .RS 4
> .IP 1. 4
> A file created inside that directory will inherit all entries with th=
e

s/all entries with/all of the directories entries that/

> .B file_inherit
> flag set, and all inheritance-related flags in the inherited entries =
will be
> cleared.
>=20
> A subdirectory will inherit all entries with the
> .B file_inherit
> or
> .B dir_inherit
> flag set.  Entries whose
> .B no_propagate
> flag is set will have all inheritance-related flags cleared.  Entries=
 whose
> .B no_propagate
> and
> .B dir_inherit
> flags are not set and whose
> .B file_inherit
> is set will have their
> .B inherit_only
> flag set.
> .IP 2.
> If the parent directory's ACL has the
> .B auto_inherit
> flag set, the inherited ACL will have its
> .B auto_inherit
> flag set, and all entries will have their
> .B inherited
> flag set.
> .IP 3.
> The three file masks are computed from the inherited ACL as described=
 in
> section
> .IR "COMPUTING THE MAXIMUM FILE MASKS" .
> .IP 4.
> The three sets of permissions for the owner, the group, and for other=
s in
> the mode parameter of the creating system call are converted into set=
s of
> richacl permissions as described in section

s/in/in the/

> .IR "Changing The File Mode Permission Bits" .
> Any richacl permissions not included in those sets are
> removed from the owner, group, and other file masks. The file mode pe=
rmission
> bits are then computed from the file masks as described in section

s/in/in the/

> .IR "Assigning An Access Control List" .
> .IP 5.
> The
> .B masked
> ACL flag is set. The
> .B write_through
> ACL flag remains cleared. In addition, if the
> .B auto_inherit
> flag of the inherited ACL is set, the
> .B protected
> flag is also set to prevent the Automatic Inheritance algorithm from =
modifying
> the ACL.
> .RE
> .PP
> When a directory does not have inheritable ACL entries, files
> and directories created inside that directory will not be assigned ac=
cess
> control lists and the file mode permission bits will be set to (mode\=
 &\
> ~umask).

will be set to

    (mode & umask)

where
=2EI mode
is the permission mode argument of the relevant system call and
=2EI umask
is the process umask (see
=2EBR umask (2)).

>=20
> .SS Automatic Inheritance

I'd use lower case in the above for all words except the first

> Automatic Inheritance allows permission changes to propagate from a d=
irectory
> to files and subdirectories inside that directory, recursively.  Carr=
ying out
> this propagation of permissions is the responsibility of the process =
changing
> the directory permissions (usually, setrichacl(1)).

I'm confused by the previous sentence. the feature is labeled "Automati=
c
Inheritance", implying that the user/process need do nothing. The next
sentence says "propagation ... is the responsibility of the process".
These two points seem contradictory. I think something more needs to be
said here.

>=20
> A significant limitation is that this mechanism works only as long as=
 files
> are created without explicitly specifying the file permissions to use=
=2E The
> standard system calls for creating files an directories (creat(2), op=
en(2),
> mkdir(2), mkfifo(2), mknod(2)) all have mandatory mode parameters whi=
ch define

=46ormat that system call list as
=2ERB ( creat (2),
=2EBR open (2),
=2EBR mkdir (2),
=2EBR mknod (2))

Note that I removed mkfifo(): it's a library functionlayered on
mkonod(2).

> the maximum allowed permissions of the new files. To take account of =
this
> restriction, the
> .B protected
> ACL flag must be set if the
> .B inherited
> flag is set. This effectively disables Automatic Inheritance for that
> particular file.
>=20
> Automatic Inheritance still remains useful for network protocols like=
 NFSv4 and
> SMB, which both support creating files and directories without defini=
ng which
> permissions: they can implement those operations by using the standar=
d system
> calls and by then undoing the effect of applying the mode parameters.
>=20
> When the ACL of a directory is changed, the following should

Why "should"?

> happen for each entry inside that directory (for each \(lqchild\(rq):

Make the preceding line:

happen for each entry (\(lqchild\(rq) inside that directory:

> .IP 1. 4
> If the entry is a symblic link, skip the child.
> .IP 2.
> If the
> .B auto_inherit
> flag of the entry's ACL is not set or the
> .B protected
> flag is set, skip the child.
> .IP 3.
> With the child's ACL:
> .RS 4
> .IP 1. 4

s/1./a)/

(i.e., use a different labeling scheme for the sublist)

> If the
> .B defaulted
> flag is set, replace the ACL with an empty ACL
> with the
> .B auto_inherit
> flag set.
> .IP 2.

s/2./b)/

> Delete all entries which have the
> .B inherited
> flag set.
> .IP 3.

s/3./c)/

> Append all entries inherited from the parent directory according to s=
tep 1 of
> the algorithm described under
> .IR "Permissions At File Create Time".
> Set the
> .B inherited
> flag of each of these entries.
> .IP 4.

s/4./d)/

> Recompute the file masks.
> .RE
> .IP 4.
> If the child is a directory, recursively apply this algorithm.
>=20
> .SH ACCESS CHECK ALGORITHM
>=20
> When a process requests a particular kind of access to a file defined=
 by a set

s/defined/protected/ (?)

> of richacl permissions, the following algorithm determines if the acc=
ess is

s/if/whether/

> granted or denied:
>=20
> .IP 1. 4
> If the
> .B masked
> ACL flag is set, then:
> .RS 4
> .IP 1. 4

s/1./a)/

Use a different numbering scheme for sublists.

> if the

s/if/If/

> .B write_through
> ACL flag is set, then:
> .RS 4
> .IP \(bu 4
> if the requesting process is the file owner, then access is granted i=
f the

s/if/If/

> owner mask includes the requested permissions, and is otherwise denie=
d.
> .IP \(bu
> if the requesting process is not the file owner, is not in the owning=
 group,

s/if/If/

> and no ACL entries other than
> .B everyone@
> match the process, then access is granted if the other mask includes =
the
> requested permissions, and is otherwise denied.
> .RE
> .IP 2.

s/2./b)/

> if any of the following is true:

s/if/If/

> .RS 4
> .IP \(bu 4
> the requesting process is the file owner and the owner mask does no i=
nclude all

s/no /not /

> requested permissions,
> .IP \(bu 4
> the requesting process is not the file owner and it is in the owning =
group or
> matches any ACL entries other than
> .BR everyone@ ,
> and the group mask does no include all requested permissions,
> .IP \(bu 4
> the requesting process is not the file owner, not in the owning group=
, it
> matches no ACL entries other than
> .BR everyone@ ,
> and the other mask does no include all requested permissions,
> .PP
> then access is denied.
> .RE
> .RE
> .IP 2.
> Set the remaining permissions to the requested permissions.  Go throu=
gh all ACL
> entries. For each entry:
> .RS 4
> .IP 1. 4

s/1./a)/

Use a different numbering scheme for sublists.

> if the
> .B inherit_only
> or
> .B unmapped
> flags are set, continue with the next ACL entry.
> .IP 2.

s/2./b)/

> if any of the following is true:
> .RS 4
> .IP \(bu 4
> the entry's identifier is
> .B owner@
> and the requesting process is the file owner,
> .IP \(bu
> the entry's identifier is
> .B group@
> and the requesting process is in the owning group,
> .IP \(bu
> the entry's identifier is a user and the requesting process is owned =
by that
> user,
> .IP \(bu
> the entry's identifier is a group and the requesting process is a mem=
ber in
> that group,
> .IP \(bu
> the entry's identifier is
> .BR everyone@ ,
> .PP
> the entry matches the process; proceed. Otherwise, continue with the =
next ACL

s/proceed/proceed to the next step/  (?)

> entry.
> .RE
> .IP 3.

s/3./c)/

> If the entry denies any of the remaining permissions, access is denie=
d.
> .IP 4.

s/4./d)/

> If the entry allows any of the remaining permissions, then:
> .RS 4
> .IP \(bu 4
> if the
> .B masked
> ACL flag is set and the entry's identifier is not
> .B owner@
> or
> .BR everyone@
> or is a user entry matching the file owner, remove all permissions fr=
om the
> remaining permissions which are both allowed by the entry and include=
d in the
> group mask,
> .IP \(bu
> otherwise, remove all permissions from the remaining permissions wich=
 are
> allowed by the entry.
> .RE
> .RE
> .IP 3.
> If there are no more remaining permissions, access is allowed. Otherw=
ise,
> access is denied.
>=20
> .SH COMPUTING THE MAXIMUM FILE MASKS
> When setting an ACL and no file masks have been explicitly specified =
and when
> inheriting an ACL from the parent directory, the following algorithm =
is used
> for computing the file masks:
>=20
> .IP 1. 4
> Clear the owner, group, and other file masks. Remember which permissi=
ons have
> already been processed (initially, the empty set).
> .IP 2.
> For each ACL entry:
> .RS 4
> .IP \(bu 4
> If the
> .B inherit_only
> flag is set, skip the entry.
> .IP \(bu 4
> Otherwise, compute which permissions the entry allows or denies that =
have not
> been processed yet (the remaining permissions).
> .IP \(bu
> If the entry is an
> .B owner@
> entry, add the remaining permissions to the owner mask for
> .B allow
> entries, and remove the remaining permissions from the owner mask for
> .B deny
> entries.
> .IP \(bu
> Otherwise, if the entry is an
> .B everyone@
> entry, proceed as with
> .B owner@
> entries but add or remove the remaining permissions from the owner, g=
roup, and
> other file masks.
> .IP \(bu
> Otherwise, proceed as with
> .B owner@
> entries but add or remove the remaining permissions from the owner an=
d group
> file masks.
> .IP \(bu
> Add the entry's permissions to the processed permissions.
> .RE
> .PP
> The resulting file masks represent the ACL as closely as possible. Wi=
th these
> file masks, if the
> .B masked
> ACL flag is set, the effective permissions still stay the same.

This page is in *desperate* need of *multiple* examples, starting simpl=
e,
and building up in complexity, with walkthogh text explaining how the
permisssions are interpreted and how the masks are generated.
Having read the page multiple times (and having little knowledge
of NFS ACLs), I'm still struggling to put all the pieces together.
Probably some examples that relate to an NFS context would also be
helpful.

> .\" .SH BUGS
> .SH AUTHOR
> Written by Andreas Gr=C3=BCnbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>.
>=20
> Please send your bug reports, suggested features and comments to the =
above address.
>=20
> .SH CONFORMING TO
> Rich Access Control Lists are Linux-specific.
> .SH SEE ALSO
> .BR chmod (1),
> .BR getrichacl (1),
> .BR ls (1),
> .BR setrichacl (1)
> .BR stat (2),
> .BR umask (2),
> .BR acl (7)
> .\" librichacl

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
