From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: richacl(7) man page review comments
Date: Sun, 21 Feb 2016 22:40:59 +0100
Message-ID: <56CA2EEB.9080504@gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
 <CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
 <56C0F23C.7030902@gmail.com>
 <CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Andreas,

On 02/20/2016 05:37 PM, Andreas Gruenbacher wrote:
> Hi Michael,
>=20
> thanks again for all the feedback. I've followed all your suggestions=
;
> again, please see the github repo for the latest version:
>=20
>   https://github.com/andreas-gruenbacher/richacl

I've once more pulled from the latest git; here's some more comments.

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
> .de URL
> \\$2 \(laURL: \\$1 \(ra\\$3
> ..
> .if \n[.g] .mso www.tmac
> .TH RICHACL 7 2015-09-01 "Linux" "Rich Access Control Lists"
> .SH NAME
> richacl \- Rich Access Control Lists
> .SH DESCRIPTION
> Rich Access Control Lists (RichACLs) are an extension of the POSIX fi=
le
> permission model (see
> .BR acl (5))
> to support
> .URL https://tools.ietf.org/rfc/rfc5661.txt "NFSv4 Access Control Lis=
ts"
> on local and remote-mounted filesystems.
>=20
> A RichACL can always be translated into an equivalent NFSv4 ACL which=
 grants
> the same permissions.
>=20
> RichACLs can be enabled on supported local filesystems (currently, ex=
t4 and
> XFS).  This disables POSIX Access Control Lists; the two ACL models c=
annot
> coexist on the same filesystem.
>=20
> The in-kernel NFSv4 server and client also include RichACL support.

Rewrite the preceding two paras in a better logical split and order:

[[
RichACLs can be enabled on supported local filesystems (currently, ext4=
 and
XFS).  The in-kernel NFSv4 server and client also include RichACL suppo=
rt.

Enabling RichACLs disables POSIX Access Control Lists;
the two ACL models cannot coexist on the same filesystem.
]]

>=20
> When used on a filesystem that does not support RichACLs, the
> .BR getrichacl (1)
> and
> .BR setrichacl (1)
> utilities will operate on the file permission bits instead:
> .BR getrichacl (1)
> will display the file permission bits as a RichACL; when a RichACL
> is set with
> .BR setrichacl (1)
> which can be represented exactly by the file permission bits,
> .BR setrichacl (1)
> will set the file permission bits instead.  An attempt to set a RichA=
CL that
> cannot be represented exactly by the file permission bits results in =
an error.
>=20
> .SS Structure of RichACLs
>=20
> RichACLs consist of a number of ACL entries, three file masks, and so=
me flags

s/some flags/a set of flags/

> specifying attributes of the ACL as whole (by contrast with the per-A=
CL-entry

s/whole/a whole/

> flags described below).
>=20
> Each of the ACL entries allows or denies some permissions to a partic=
ular user,
> group, or special identifier. An ACL entry consists of four fields:
>=20
> .IP \(bu 4

s/4/2/

> A tag which specifies the user, group, or special identifier the entr=
y applies
> to.  Special identifiers can be the file owner, the owning group, or =
everyone.

=3D=3D>
Special identifiers correspond to one of three file masks for the file =
owner
=2ERB ( owner@ ),
the owning group
=2ERB ( group@ ),
or everyone
=2ERB ( everyone@ ).

> .IP \(bu
> A set of permissions the entry allows or denies.
> .IP \(bu
> A set of flags that indicate whether the user or group identifier is =
mapped or
> unmapped, and whether the entry has been and can be inherited.
> .IP \(bu 4

s/ 4//

> A type field indicating whether the entry allows or denies access.

s/access/the permissions specified in the second field/

> .PP
> The owner, group, and other file masks further control which permissi=
ons the
> ACL grants, subject to the
> .BR masked "\ (" m )
> and
> .BR write_through "\ (" w )
> ACL flags: when the permissions of a file or directory are changed wi=
th
> .BR chmod (2),
> the file masks are set based on the new file mode, and the
> .B masked
> and
> .B write_through
> ACL flags are set. Likewise, when a new file or directory inherits an=
 ACL from
> its parent directory, the file masks are set to the intersection betw=
een the
> permissions granted by the inherited ACL and the
> .I mode
> parameter as given to
> .BR open "(2), " mkdir (2),
> and similar, and the
> .B masked
> ACL flag is set. In both cases, the file masks limit the permissions =
that the
> ACL will grant.
>=20
> The advantage of this approach over directly modifying the ACL entrie=
s is that
> permissions defined in ACL entries are not lot when the file masks ar=
e later

s/lot/lost/

> set to be less restrictive.

(I think) I know what you are trying to say in the previous paragraph,
but "this approach" and "directly modifying the ACL entries" is a littl=
e
vague.  Masks are about solving the hysteresis problem, right? So, how
about some text along the following lines (I'm sure you can improve):

[[
The purpose of the file masks is to allow applications that are unaware
of RichACLs to place limits on the permissions granted by various
classes of RichACL in a manner that corresponds to the traditional
user/group/other semantics, without modifying the ACL entries in those
classes.  Without the file masks, the only alternative would be for the
kernel to directly modify the ACL entries in those classes. However,
this latter approach could have a "hysteresis effect", whereby
a RichACL-unaware application that performs a transition from one file
mode to another file mode and then back to the original file mode
could cause destruction of the permission information in ACL entries.
]]

>=20
> Note that entries with the identifier
> .B everyone@
> apply to all processes, whereas the \(lqother\(rq file permissions an=
d
> \(lqother\(rq entries in POSIX ACLs apply to all processes which are =
not the

I'd be inclined to use (or add) \fBACL_OTHER\fP instead of "other"
in the preceding line.  Things makes things IMO a little clearer when
you try to distinguish from "other" file permissions.

> owner, are not in the owning group, and do not match a user or group =
mentioned
> in the ACL.
>=20
> Unlike POSIX ACLs, RichACLs do not have separate \(lqaccess\(rq ACLs =
that
> define the access permissions and \(lqdefault\(rq ACLs that define th=
e
> inheritable permissions.  Instead, flags on each ACL entry determine =
whether
> the entry is effective during access checks and/or inheritable.
>=20
>=20
> .SS ACL flags
>=20
> The following flags on ACLs are defined:

s/flags on ACLs/ACL flags/

>=20
> .TP
> .BR masked "\ (" m )
> When set, the file masks define upper limits on the permissions the A=
CL may
> grant.  When not set, the file masks are ignored.
> .TP
> .BR write_through "\ (" w )
> When this flag and the
> .B masked
> flag are both set, the owner and other file masks define the actual p=
ermissions
> granted to the file owner and to others instead of defining an upper =
limit.
> When the
> .B masked
> flag is not set, the write_through flag has no effect.

Use .BR write_through for preceding line

> .TP
> .BR auto_inherit "\ (" a )
> Automatic Inheritance is enabled.  See
> .IR "Automatic Inheritance" .
> .TP
> .BR protected "\ (" p )
> The ACL is protected from modification by Automatic
> Inheritance.
> .TP
> .BR defaulted "\ (" d )
> Indicates that the ACL has been assigned in an application-dependent =
way when
> the file or directory was created; it has neither been inherited nor =
set
> explicitly. ACLs of files created on Linux will never have the
> .B defaulted
> flag set.=20

The preceding sentence immediately triggers an obvious question for the
reader.  So, do we need a sentence here to say when/where the "defaulte=
d"
flag is set?
>           When this flag is set for an ACL, Automatic Inheritance wil=
l
> completely replace the ACL.
>=20
> .SS ACL entry flags
>=20
> The following flags on ACL entries are defined:
>=20
> .TP
> .BR file_inherit "\ (" f )
> When this flag appears in the ACL entry of a directory, then:
> .RS
> .IP \(bu 4
> That entry is inherited by new files created in the directory such th=
at the

s/4/2/

> permissions of the entry apply to the file (the inheritance flags of =
the
> inherited entry are cleared).
> .IP \(bu 4
> The entry is is inherited by new subdirectories created in the direct=
ory such

s/ 4//

> that the permissions of the entry will apply to new files created in =
the
> subdirectory.
> .RE
> .TP
> .BR dir_inherit "\ (" d )
> When this flag appears in the ACL entry of a directory, then that ent=
ry is
> inherited by new subdirectories created in the directory such that th=
e
> permissions of the entry apply to the subdirectory (the
> .B inherit_only
> flag is cleared).
> .TP
> .BR no_propagate "\ (" n )
> Inheritance stops at the next subdirectory level.  When a file or dir=
ectory
> inherits an entry that has this flag set, the
> .BR file_inherit ", " dir_inherit ", " no_propagate ", and " inherit_=
only
> flags are cleared.
> .TP
> .BR inherit_only "\ (" i )
> The entry defines inheritable permissions only and is ignored for acc=
ess
> checking.  When a file or directory inherits an entry that has this f=
lag set,
> the flag is cleared.
> .TP
> .BR inherited "\ (" a )
> The entry has been automatically inherited from the parent directory;=
 the
> ACL's
> .B auto_inherit
> flag should be on.

Why "should be" in the previous sentence? I think a little explanation
is needed here...
> .TP
> .BR unmapped "\ (" u )
> The user or group identifier is a textual string and is not mapped to=
 a numeric
> user or group identifier.  ACLs with unmapped identifiers can occur o=
n NFSv4
> mounted filesystems when the client cannot determine numeric user or =
group
> identifiers for some of the NFSv4 user@domain or group@domain who val=
ues.  They
> cannot be assigned to local files or directories.
>=20
> .SS Permissions
>=20
> The following permissions are defined for RichACL entries and for the=
 three
> file masks:
>=20
> .TP
> .BR read_data " / " list_directory "\ (" r )
> For a file: read the data of the file.
> For a directory: list the contents of the directory.
> .TP
> .BR write_data " / " add_file "\ (" w )
> For a file: modify the data of the file; does not include opening the=
 file in
> append mode.
> For a directory: add a new file in the directory.
> .TP
> .BR append_data " / " add_subdirectory "\ (" p )
> For a file: open the file in append mode.
> For a directory: create a subdirectory in the directory.
> .TP
> .BR execute "\ (" x )
> For a file: execute the file.
> For a directory: traverse / search the directory.

s%traverse / search%traverse (search)%
> .TP
> .BR delete_child "\ (" d )
> Delete a file or directory within a directory.  This permission is me=
aningless
> for non-directories.

=3D=3D> "This permission is meanungful only for directories."

> .TP
> .BR delete "\ (" D )
> Delete the file or directory.
> .TP
> .BR read_attributes "\ (" a )
> Read basic attributes of a file or directory (see
> .BR stat (2)).
> This permission is defined by NFSv4.  It is stored, but ignored.  Rea=
ding basic
> attributes of files and directories is always allowed on Linux.
> .TP
> .BR write_attributes "\ (" A )
> Change the times associated with a file or directory to an arbitrary =
value.
> This permission is always implicitly granted to the file owner.
> .TP
> .BR read_acl "\ (" c )
> Read the ACL of a file or directory. This permission is always
> implicitly granted.

So, I think a sentence explaining why "read_acl" exists would be
helpful, since the reader is left a little puzzled about its purpose if
it is always implicitly granted.

> .TP
> .BR write_acl "\ (" C )
> Change the ACL or file mode of a file or directory.
> .TP
> .BR write_owner "\ (" o )
> Take ownership of a file or directory.  Change the owning group of a =
file or
> directory to a group of which the calling process is a member.
> .TP

=46ormatting tweak: add ".ad l" before the following line amd ".ad" aft=
er
the line.

> .BR read_named_attrs "\ (" R "), " write_named_attrs "\ (" W "), " sy=
nchronize "\ (" S "), " write_retention "\ (" e "), " write_retention_h=
old "\ (" E )
> These permissions are defined by NFSv4 / NFSv4.1.  They are stored, b=
ut ignored.

s%/%and%

> .PP
> For the
> .BR r ", " w ", and " p
> permissions which have different long forms for files and directories=
, the

s/permissions/permissions,/

> .BR getrichacl (1)
> utility will output the appropriate form(s) depending on the context.
> The
> .BR setrichacl (1)
> utility will accept either form for any file type.
>=20
> .SS Text form
> The common textual representation of a RichACL consists of the colon-=
separated
> fields of the ACL flags, file masks, and ACL entries in the following
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
> entry flags, and the entry type. The who field is one of the followin=
g:

s/who/\\fIwho\\fP/

> .RS
> .IP \(bu 4

s/4/2/

> One of the special identifiers:
> .BR owner@ ", " group@ ", or " everyone@ ,
> .IP \(bu
> A
> .BR user: " or " u:
> prefix followed by a user name or user ID that designates a specific =
user,
> .IP \(bu
> A
> .BR group: " or " g:
> prefix followed by a group name or group ID that designates a specifi=
c group.
> .RE
> .PP
> The entries are comma, whitespace, or newline separated.
>=20
> Flags and permissions have single-letter as well as long forms, as li=
sted under
> .IR "ACL flags" ,
> .IR "ACL entry flags" ,
> and
> .IR Permissions .
> When the single-letter forms are used, the flags or permissions are
> concatenated. When the long forms are used, the flags or permissions =
are
> separated by slashes.  To align permissions or flags vertically, dash=
es can be
> used for padding.
>=20
> .SS Setting and modifying file permissions
> The access permissions for a file can either be set by assigning an A=
ccess
> Control List
> .RB ( setrichacl (1))
> or by changing the file mode permission bits
> .RB ( chmod (1)).
> In addition, a file can inherit an ACL from its parent directory at c=
reation
> time as described under
> .IR "Permissions at file-creation time" .
>=20
> .SS Assigning an Access Control List
> When assigning an ACL to a file, unless explicitly specified, the own=
er, group,
> and other file masks will be computed from the ACL entries as describ=
ed in
> the section
> .IR "Computing the maximum file masks" .
> The owner, group, and other file mode permission bits are then each s=
et from
> the owner, group, and other file mask as follows:
> .IP \(bu 4

s/4/2/

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
> permission bits, the file permission bits are set to match the ACL an=
d the ACL
> is not stored.

Maybe better: "...and no ACL is stored"

>                (When the ACL of a file is requested which doesn't hav=
e an ACL,
> the file mode permission bits are converted into an equivalent ACL.)
>=20
> .SS Changing the file mode permission bits
> When changing the file mode permission bits with
> .BR chmod (1),
> the owner, group, and other file permission bits are set to the permi=
ssion bits
> in the new mode, and the owner, group, and other file masks are set b=
ased on
> the new mode bits as follows:
> .IP \(bu 4

s/4/2/

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
> .SS Permissions at file-creation time
> When a directory has inheritable ACL entries, the following

s/has/has an/

> happens when a file or directory is created inside that directory:
> .RS 4
> .IP 1. 4
> A file created inside that directory will inherit all of the ACL entr=
ies that
> have the
> .B file_inherit
> flag set, and all inheritance-related flags in the inherited entries =
flag will
> be cleared.
>=20
> A subdirectory created inside that directory will inherit all of the =
ACL
> entries that either have the
> .B dir_inherit
> flag set, or the
> .B file_inherit
> flag set and the
> .B no_propagate
> flag not set.  Entries whose
> .B dir_inherit
> flag is set will have their
> .B inherit_only
> flag cleared, and entries whose
> .B dir_inherit
> flag is not set will have their
> .B inherit_only
> flag set.  Finally, entries whose
> .B no_propagate
> flag is set will have all inheritance-related flags cleared.
> .IP 2.
> If the parent directory's ACL has the
> .B auto_inherit
> flag set, the inherited ACL will have its
> .B auto_inherit
> flag set, and all entries will have their
> .B inherited
> flag set.  Otherwise, the
> .B auto_inherit
> and
> .B inherited
> flags are cleared.
> .IP 3.
> The three file masks are computed from the inherited ACL as described=
 in
> the section
> .IR "Computing the maximum file masks" .
> .IP 4.
> The three sets of permissions for the owner, the group, and for other=
s in
> the \fImode\fR parameter as given to
> .BR open (2),
> .BR mkdir (2),
> and similar are converted into sets of RichACL permissions. The corre=
spondence
> between mask flags and RichACL permission bits is described in the se=
ction
> .IR "Changing the file mode permission bits" .
> Any RichACL permissions not included in those sets are
> removed from the owner, group, and other file masks. The file mode pe=
rmission
> bits are then computed from the file masks as described in the sectio=
n
> .IR "Assigning an Access Control List" .
> The process umask (see
> .BR umask (2))
> is ignored.
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
> When a directory does not have inheritable ACL entries, files and dir=
ectories
> created inside that directory will not be assigned Access Control Lis=
ts and the
> file mode permission bits will be set to (\fImode\fR\ &\ ~\fIumask\fR=
) where
> \fImode\fR is the mode argument of the relevant system call and \fIum=
ask\fR is
> the process umask (see
> .BR umask (2)).
>=20
> .SS Automatic Inheritance
> Automatic Inheritance is a mechanism that allows permission changes t=
o
> propagate from a directory to files and subdirectories inside that di=
rectory,
> recursively.  Propagation is carried out by the process changing the =
directory
> permissions (usually,
> .BR setrichacl (1));
> it happens without user intervention albeit not entirely automaticall=
y.
>=20
> A significant limitation is that this mechanism works only as long as=
 files
> are created without explicitly specifying the file permissions to use=
=2E The
> standard system calls for creating files and directories
> .RB ( creat (2),
> .BR open (2),
> .BR mkdir (2),
> .BR mknod (2))
> all have mandatory mode parameters which define the maximum allowed p=
ermissions
> of the new files. To take account of this restriction, the
> .B protected
> ACL flag must be set if the
> .B inherited
> flag is set. This effectively disables Automatic Inheritance for that
> particular file.
>=20

Add the following at the start of the next paragraph:

"Motwithstanding the aforementioned limitation,"
> Automatic Inheritance still remains useful for network protocols like=
 NFSv4 and
> SMB, which both support creating files and directories without defini=
ng their
> permissions: they can implement those operations by using the standar=
d system

s/: they/. These protocols/
(To avoid an excessively long sentence.)

> calls and by then undoing the effect of applying the mode parameters.
>=20
> When the ACL of a directory is changed, the following happens for eac=
h entry
> (\(lqchild\(rq) inside that directory:
> .IP 1. 4
> If the entry is a symblic link, skip the child.

s/symblic/symbolic/

> .IP 2.
> If the
> .B auto_inherit
> flag of the entry's ACL is not set or the
> .B protected
> flag is set, skip the child.
> .IP 3.
> With the child's ACL:
> .RS 4
> .IP a) 4
> If the
> .B defaulted
> flag is set, replace the ACL with an empty ACL
> with the
> .B auto_inherit
> flag set.
> .IP b)
> Delete all entries which have the
> .B inherited
> flag set.
> .IP c)
> Append all entries inherited from the parent directory according to s=
tep 1 of
> the algorithm described under
> .IR "Permissions at file-creation time".
> Set the
> .B inherited
> flag of each of these entries.
> .IP d)
> Recompute the file masks.
> .RE
> .IP 4.
> If the child is a directory, recursively apply this algorithm.
>=20
> .SS Access check algorithm
>=20
> When a process requests a particular kind of access (expressed as a s=
et of
> RichACL permissions) to a file, the following algorithm determines wh=
ether the
> access is granted or denied:
>=20
> .IP 1. 4
> If the
> .B masked
> ACL flag is set, then:
> .RS 4
> .IP a) 4
> If the
> .B write_through
> ACL flag is set, then:
> .RS 4

s/4/2/

> .IP \(bu 4

s/4/2/

> If the requesting process is the file owner, then access is granted i=
f the
> owner mask includes the requested permissions, and is otherwise denie=
d.
> .IP \(bu
> If the requesting process is not the file owner, is not in the owning=
 group,
> and no ACL entries other than
> .B everyone@
> match the process, then access is granted if the other mask includes =
the
> requested permissions, and is otherwise denied.

So, in the above subcases, the following does not seem to be covered:
        (1) "masked" ACL flag is set AND
        (2) requesting process *is* in owning group *or* an ACL other
            than "everyone@"matches the process.

What happens in this case? I suspect that somehow we are supposed to
fall through to part "b)" below (and possibly into clause "2."?), but
the logical structure of the clauses does not reflect this.
       =20
> .RE
> .IP b)
> If any of the following is true:
> .RS 4

s/4/2/

> .IP \(bu 4

s/4/2/

> the requesting process is the file owner and the owner mask does not =
include all
> requested permissions,
> .IP \(bu 4

s/ 4//

> the requesting process is not the file owner and it is in the owning =
group or
> matches any ACL entries other than
> .BR everyone@ ,
> and the group mask does not include all requested permissions,
> .IP \(bu 4

s/ 4//

> the requesting process is not the file owner, not in the owning group=
, it
> matches no ACL entries other than
> .BR everyone@ ,
> and the other mask does not include all requested permissions,
> .PP
> then access is denied.
> .RE
> .RE

At some point, perhaps in the next paragraph, I think that it needs to
be clarified that unlike POSIX ACLs, a process can gain the permissions
it requires by accumulating them from multiple RichACL enties. (That's
correct, is it not?)

> .IP 2.
> Set the remaining permissions to the requested permissions.  Go throu=
gh all ACL
> entries. For each entry:

So, perhaps replace the preceding two lines with something like:

[[
Upon reaching this point, the determination of whether or not access is
granted is made by scanning all ACL entries to see if one or more
applicable entries together grant a cumulative set of permissions that
matches the requested permissions or there is an applicable entry that
explicitly denies one or more of the requested permissions.
The scan of all ACL entries begins by
first initializing the set of remaining permissions (i.e., those that h=
ave
not yet been satisfied during the scan) to be the set of requested
permissions. Then the ACL entries are scanned
=2EIR "in order" ,
and for each entry:
]]

> .RS 4
> .IP a) 4
> If the
> .B inherit_only
> or
> .B unmapped
> flags are set, continue with the next ACL entry.
> .IP b)
> If any of the following is true:
> .RS 4

s/4/2/

> .IP \(bu 4

s/4/2/

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
> then the entry matches the process; proceed to the next step. Otherwi=
se,
> continue with the next ACL entry.
> .RE
> .IP c)
> If the entry denies any of the remaining permissions, access is denie=
d.
> .IP d)
> If the entry allows any of the remaining permissions, then:
> .RS 4

s/4/2/

> .IP \(bu 4

s/4/2/

> If the
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
> Otherwise, remove all permissions from the remaining permissions wich=
 are

s/wich/which=20

> allowed by the entry.
> .RE
> .RE
> .IP 3.
> If there are no more remaining permissions, access is allowed. Otherw=
ise,
> access is denied.
>=20
> .SS Computing the maximum file masks
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

s/4/2/

> .IP \(bu 4

s/4/2/

> If the
> .B inherit_only
> flag is set, skip the entry.
> .IP \(bu 4

s/ 4//

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

The meaing of "will stay the same" is not quite clear "will stay the
same *as what*"?). I suspect I know what you mean, but it needs to be
made more obvious.

>=20
> .\" .SH BUGS
> .SH AUTHOR
> Written by Andreas Gr=C3=BCnbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>.
>=20
> Please send your bug reports, suggested features and comments to the =
above address.
>=20

I'm going to play the broken record :-)

Could we start with just a few simple examples already, and build up
over future iterations of this page?

> .SH CONFORMING TO
> Rich Access Control Lists are Linux-specific.
> .SH SEE ALSO
> .BR acl (5),

Move this entry to the point XXX below.

> .BR chmod (1),
> .BR getrichacl (1),
> .BR ls (1),
> .BR setrichacl (1)
> .BR stat (2),
> .BR umask (2)
> .\" librichacl

XXX

By the way, are there already man pages for the librichacl functions?

Cheers,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
