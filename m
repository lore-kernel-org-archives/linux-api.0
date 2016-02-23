From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: richacl(7) man page review comments
Date: Tue, 23 Feb 2016 11:58:18 +0100
Message-ID: <56CC3B4A.7070204@gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
 <CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
 <56C0F23C.7030902@gmail.com>
 <CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A@mail.gmail.com>
 <56CA2EEB.9080504@gmail.com>
 <CAHc6FU46vO8NM3cvFH7b8X7U9R+m6wcYj8EQKVnSQkiY3Q051A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAHc6FU46vO8NM3cvFH7b8X7U9R+m6wcYj8EQKVnSQkiY3Q051A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: mtk.manpages@gmail.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Anna Schumaker <anna.schumaker@netapp.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, Andreas Dilger <adilger@dilger.ca>
List-Id: linux-api@vger.kernel.org

Hi Andreas,

On 02/22/2016 03:46 PM, Andreas Gruenbacher wrote:
> Hi Michael,
>=20
> On Sun, Feb 21, 2016 at 10:40 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> I've once more pulled from the latest git; here's some more comments=
=2E
>=20
> thanks again. I've updated the repo with your changes.

Next round :-). Just a few quick comments while I'm on a train ride.

> .\"
> .\" RichACL Manual Pages
> .\"
> .\" Copyright (C) 2015,2016  Red Hat, Inc.
> .\" Written by Andreas Gruenbacher <agruenba@redhat.com>
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
> XFS).  The in-kernel NFSv4 server and client also include RichACL sup=
port.
>=20
> Enabling RichACLs disables POSIX Access Control Lists; the two ACL mo=
dels
> cannot coexist on the same filesystem.
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
> RichACLs consist of a number of ACL entries, three file masks, and a =
set of
> flags specifying attributes of the ACL as a whole (by contrast with t=
he
> per-ACL-entry flags described below).
>=20
> Each of the ACL entries allows or denies some permissions to a partic=
ular user,
> group, or special identifier. An ACL entry consists of four fields:
>=20
> .IP \(bu 2
> A tag which specifies the user, group, or special identifier the entr=
y applies
> to.  Special identifiers can be the file owner
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
> .IP \(bu
> A type field indicating whether the entry allows or denies the permis=
sions
> specified in the second field.
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
> The purpose of the file masks is to allow traditional POSIX applicati=
ons which
> are unaware of RichACLs to place limits on the permissions granted by=
 the
> RichACL without causing the ACL entries to be modified.  Without the =
file mask,
> the only alternative would be for the kernel to directly modify the A=
CL
> entries.  However, this latter approach could have a "hysteresis effe=
ct",
> whereby a RichACL-unaware application that performs a transition from=
 one file
> mode to another file mode and then back to the original file mode cou=
ld cause
> destruction of the permission information in ACL entries.  When creat=
ing files
> or directories, the
> .I mode
> parameter to
> .BR open "(2), " mkdir (2),
> and similar would cause the same effect.

s/cause/have/

>=20
> Note that entries with the identifier
> .B everyone@
> apply to all processes, whereas the \(lqother\(rq file permissions an=
d
> \(lqother\(rq entries in POSIX ACLs apply to all processes which are =
not the

So, I still think it's helpful to mention ACL_OTHER here. How about:

s/\\(lqother\\(rq/\\(lqother\\(rq (\\fBACL_OTHER\\fP)/

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
> The following ACL flags are defined:
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
> flag is not set, the
> .B write_through
> flag has no effect.
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
> flag set, but the flag may be set on files created on or copied over =
from
> other operating systems.  When this flag is set for an ACL, Automatic
> Inheritance will completely replace the ACL.
>=20
> .SS ACL entry flags
>=20
> The following flags on ACL entries are defined:
>=20
> .TP
> .BR file_inherit "\ (" f )
> When this flag appears in the ACL entry of a directory, then:
> .RS
> .IP \(bu 2
> That entry is inherited by new files created in the directory such th=
at the
> permissions of the entry apply to the file (the inheritance flags of =
the
> inherited entry are cleared).
> .IP \(bu
> The entry is is inherited by new subdirectories created in the direct=
ory such
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
> The entry has been automatically inherited from the parent directory.
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
> For a directory: traverse (search) the directory.
> .TP
> .BR delete_child "\ (" d )
> Delete a file or directory within a directory.  This permission is me=
aningful
> only for directories.
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
> Read the ACL of a file or directory. Like reading the basic file attr=
ibutes (the
> .B read_attributes
> permission), reading ACLs is always allowed in Linux.
> .TP
> .BR write_acl "\ (" C )
> Change the ACL or file mode of a file or directory.
> .TP
> .BR write_owner "\ (" o )
> Take ownership of a file or directory.  Change the owning group of a =
file or
> directory to a group of which the calling process is a member.
> .TP
> .ad l
> .BR read_named_attrs "\ (" R "), " write_named_attrs "\ (" W "), " sy=
nchronize "\ (" S "), " write_retention "\ (" e "), " write_retention_h=
old "\ (" E )
> .ad
> These permissions are defined by NFSv4 and NFSv4.1.  They are stored,=
 but ignored.
> .PP
> For the
> .BR r ", " w ", and " p
> permissions, which have different long forms for files and directorie=
s, the
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
> entry flags, and the entry type. The \fIwho\fR field is one of the fo=
llowing:
> .RS
> .IP \(bu 2
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

s/entries/fields of an ACL entry/ (?)

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
> .IP \(bu 2
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
> If the ACL can be represented exactly by the file mode permission bit=
s, the
> file permission bits are set to match the ACL and no ACL is stored.  =
(When the
> ACL of a file is requested which doesn't have an ACL, the file mode p=
ermission
> bits are converted into an equivalent ACL.)
>=20
> .SS Changing the file mode permission bits
> When changing the file mode permission bits with
> .BR chmod (1),
> the owner, group, and other file permission bits are set to the permi=
ssion bits
> in the new mode, and the owner, group, and other file masks are set b=
ased on
> the new mode bits as follows:
> .IP \(bu 2
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
> When a directory has any inheritable ACL entries, the following
> happens when a file or directory is created inside that directory:
> .RS 4

Remove preceding line.

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

s/the/then the/
(For ease of parsing)

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

Remove preceding line.

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

s/limitation/limitation of the Automatic Inheritance feature/

> are created without explicitly specifying the file permissions to use=
=2E The
> standard system calls for creating files and directories
> .RB ( creat (2),
> .BR open (2),
> .BR mkdir (2),
> .BR mknod (2))

s/)$/,\nand so on)/

(And, I'd drop creat(2) from that list of examples. It's ancient and
obsolete; no need to encourageits use.)

> all have mandatory mode parameters which define the maximum allowed p=
ermissions
> of the new files. To take account of this restriction, the
> .B protected
> ACL flag must be set if the
> .B inherited
> flag is set. This effectively disables Automatic Inheritance for that
> particular file.
>=20
> Notwithstanding the aforementioned limitation, Automatic Inheritance =
still
> remains useful for network protocols like NFSv4 and SMB, which both s=
upport
> creating files and directories without defining their permissions. Th=
ese
> protocols can implement those operations by using the standard system=
 calls and
> by then undoing the effect of applying the mode parameters.
>=20
> When the ACL of a directory is changed, the following happens for eac=
h entry
> (\(lqchild\(rq) inside that directory:
> .IP 1. 4
> If the entry is a symbolic link, skip the child.
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

At th end of the last section, add:

        as descibed in the section "...."

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
> .IP \(bu 2
> If the requesting process is the file owner, then access is granted i=
f the
> owner mask includes the requested permissions, and is otherwise denie=
d.
> .IP \(bu
> If the requesting process is not the file owner and it is in the owni=
ng group or matches any ACL entries other than
> .BR everyone@ ,
> proceed to step b).
> .IP \(bu
> If the requesting process is not the file owner, is not in the owning=
 group,
> and no ACL entries other than
> .B everyone@
> match the process, then access is granted if the other mask includes =
the
> requested permissions, and is otherwise denied.
> .RE
> .IP b)
> If any of the following is true:
> .RS 4
> .IP \(bu 2
> the requesting process is the file owner and the owner mask does not =
include all
> requested permissions,
> .IP \(bu
> the requesting process is not the file owner and it is in the owning =
group or
> matches any ACL entries other than
> .BR everyone@ ,
> and the group mask does not include all requested permissions,
> .IP \(bu
> the requesting process is not the file owner, not in the owning group=
, it
> matches no ACL entries other than
> .BR everyone@ ,
> and the other mask does not include all requested permissions,
> .PP
> then access is denied.
> .RE
> .RE
> .IP 2.
> Upon reaching this point, the determination of whether or not access =
is granted
> is made by scanning all ACL entries to see if one or more applicable =
entries
> together grant a cumulative set of permissions that matches the reque=
sted
> permissions or there is an applicable entry that explicitly denies on=
e or more
> of the requested permissions.  The scan of all ACL entries begins by =
first
> initializing the set of remaining permissions (i.e., those that have =
not yet
> been satisfied during the scan) to be the set of requested permission=
s. Then
> the ACL entries are scanned
> .IR "in order" ,
> and for each entry:
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
> .IP \(bu 2
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
> .IP \(bu 2
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
> Otherwise, remove all permissions from the remaining permissions whic=
h are
> allowed by the entry.
> .RE
> .RE
> .IP 3.
> If there are no more remaining permissions, access is allowed. Otherw=
ise,
> access is denied.
> .PP
> In this algorithm, a process can gain the permissions it requires by
> accumulating them from multiple RichACL entries.  This is in contrast=
 with
> POSIX ACLs, where access is only granted if an ACL entry exists that =
matches
> the requesting process and includes all the requested permissions.
>=20
> .SS Computing the maximum file masks
> When setting an ACL and no file masks have been explicitly specified =
and when
> inheriting an ACL from the parent directory, the following algorithm =
is used

s/directory/directory (as described in section "....")/

> for computing the file masks:
>=20
> .IP 1. 4
> Clear the owner, group, and other file masks. Remember which permissi=
ons have
> already been processed (initially, the empty set).
> .IP 2.
> For each ACL entry:
> .RS 4
> .IP \(bu 2
> If the
> .B inherit_only
> flag is set, skip the entry.
> .IP \(bu
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
> file masks, the effective permissions that the ACL grants will be the=
 same when
> the
> .B masked
> flag is set as when it is not set.
>=20
> .\" .SH BUGS
> .SH AUTHOR
> Written by Andreas Gr=C3=BCnbacher <agruenba@redhat.com>.
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
> .BR acl (5)
> .\" librichacl

So, in terms of actually testing this stuff, is it just a matter of
applying your patch series to the kernel, building the kernel, pulling
the RichACL user-space tools from Git, and mount(8)ing a filesystem wit=
h
the right option?

Cheers,

Michael




--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
