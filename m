From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: richacl(7) man page review comments
Date: Sun, 14 Feb 2016 22:31:40 +0100
Message-ID: <56C0F23C.7030902@gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
 <CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andreas,

Here's a few more comments on the current richacl(7) page
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

Having read the following paragraph a number of times (and being
ignorant of NFS ACLs), I find that I'm none the wiser about what you ar=
e
trying to say. What does it mean to "apply a file mode to an... ACL"?
Likewise, how does "the file mode determine the values of the file
masks"? This isn't clear in the following paragraph, and doesn't seem t=
o
be alborated in the rest of the page. Could you add some text somehwere
to explain these points?

> RichACLs support file masks which can be used to apply a file mode to=
 an existing
> NFSv4 ACL without destructive side effects: the file mode determines =
the values
> of the file masks; the file masks restrict the permissions granted by=
 the NFSv4
> ACL.  When a less restrictive file mode is applied later, the file ma=
sks become
> less restrictive, and more of the original permissions can become eff=
ective.
>=20
> A RichACL can always be translated into an equivalent NFSv4 ACL which=
 grants
> the same permissions.
>=20
> RichACLs can be enabled on supported filesystems. This disables POSIX=
 Access

I think it might be helpful here to list which filesystems so far
support RichACLs.

> Control Lists; the two ACL models cannot coexist on the same filesyst=
em.
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
> specifying attributes of the ACL as whole (by contrast with the per-A=
CL-entry
> flags described below).

Insert a blank line here, to start a new paragraph.

> Each of the ACL entries allows or denies some permissions to a partic=
ular user,
> group, or special entity. Each entry consists of:

In the previous line you write "entity". In the lines below you use
"identifier". The terminology switch is confusing. Use just one
term.
=20
> .IP \(bu 4
> A tag which specifies the user (with prefix
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

Does this field have a name? It would make dicussing it easier
to give it a name. That is, an ACL entry consists of four fields:

* a tag
* permissions
* flags
* ??? ("type"?)

> .PP
> The owner, group, and other file masks further control which permissi=
ons the
> ACL grants, subject to the
> .BR masked "\ (" m )
> and
> .BR write_through "\ (" w )
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
>=20
> .RS
> .HP

I don't think the heavy indentation here is helpful, and it narrors the
text considerably. I suggest replacing the preceding .RS+.HP with .TP,
and changing ewach .HP below to .TP, and remove the colon at the end of
each line that follows the .TP lines.

> .BR masked "\ (" m ):
> When set, the file masks define upper limits on the permissions the A=
CL may
> grant.
> .HP
> .BR write_through "\ (" w ):
> When this flag and the
> .B masked
> flag are both set, the owner and other file masks define the actual p=
ermissions
> granted to the file owner and to others instead of an upper limit.

There needs to be a statement here about what 'write_through' does if
'masked' is not set.

> .HP
> .BR auto_inherit "\ (" a ):
> Automatic Inheritance is enabled for the file the ACL is
> attached to. See
> .IR "Automatic Inheritance" .
> .HP
> .BR protected "\ (" p ):
> The ACL is protected from modification by Automatic
> Inheritance.
> .HP
> .BR defaulted "\ (" d ):
> The ACL has been assigned by default. Automatic Inheritance should co=
mpletely

What does "assigned by default" mean? That it was inherited because of
'dir_inherit' or 'file_inherit' in the pareent directory? This needs to
be clearer.


> replace the ACL.
> .RE

If you follow my suggestion above, delete the preceding .RE

> .SS ACL entry flags
>=20
> The following flags on ACL entries are defined:
>=20
> .RS
> .HP

See above. Possibly change .RS+.HP to .TP

> .BR file_inherit "\ (" f ):
> The entry is inheritable for files.

Maybe this would be better as:

"When this flag appears in the ACL entry of a directory, then that entr=
y is
inherited by new files created in the directory."

Is that text that I propose correct?

> .HP
> .BR dir_inherit "\ (" d ):
> The entry is inheritable for directories.

"When this flag appears in the ACL entry of a directory, then that entr=
y is
inherited by new subdirectories created in the directory."

Is that text that I propose correct?

> .HP
> .BR no_propagate "\ (" n ):
> Inheritance stops at the next subdirectory level.
> .HP
> .BR inherit_only "\ (" i ):
> The entry defines inheritable permissions only and is ignored for acc=
ess
> checking.
> .HP
> .BR inherited "\ (" a ):
> The entry has been automatically inherited from the parent directory;=
 the
> ACL's
> .B auto_inherit
> flag should be on.
> .HP
> .BR unmapped "\ (" u ):
> The user or group identifier is a textual string and is not mapped to=
 a numeric
> user or group identifier.  ACLs with unmapped identifiers can occur o=
n NFSv4
> mounted filesystems when the client cannot determine numeric user or =
group
> identifiers for some of the NFSv4 user@domain or group@domain who val=
ues.  They
> cannot be assigned to local files or directories.
> .RE

If you follow my suggestion above, delete the preceding .RE

>=20
> .SS Permissions
>=20
> The following permissions are defined for RichACL entries and for the=
 three
> file masks:
>=20
> .RS
> .HP

See above. Possibly change .RS+.HP yo .TP

> .BR read_data " / " list_directory "\ (" r ):
> For a file: read the data of the file.
> For a directory: list the contents of the directory.
> .HP
> .BR write_data " / " add_file "\ (" w ):
> For a file: modify the data of the file; does not include opening the=
 file in
> append mode.
> For a directory: add a new file in the directory.
> .HP
> .BR append_data " / " add_subdirectory "\ (" p ):
> For a file: open the file in append mode.
> For a directory: create a subdirectory in the directory.
> .HP
> .BR execute "\ (" x ):
> For a file: execute the file.
> For a directory: traverse / search the directory.
> .HP
> .BR delete_child "\ (" d ):
> Delete a file or directory within a directory.
> .HP
> .BR delete "\ (" D ):
> Delete the file or directory.
> .HP
> .BR read_attributes "\ (" a ):
> Read basic attributes of a file or directory (see
> .BR stat (2)).
> This permission is always implicitly granted.

So, can this permission ever be taken away? If yes, say so. If not, why
does this permission exist? (And maybe say something about that.)

> .HP
> .BR write_attributes "\ (" A ):
> Change the times associated with a file or directory to an arbitrary =
value.
> This permission is always implicitly granted to the file owner.
> .HP
> .BR read_acl "\ (" c ):
> Read the ACL of a file or directory. This permission is always
> implicitly granted.
> .HP
> .BR write_acl "\ (" C ):
> Change the ACL or file mode of a file or directory.
> .HP
> .BR write_owner "\ (" o ):
> Take ownership of a file or directory.  Change the owning group of a =
file or
> directory to a group of which the calling process is a member.
> .HP
> .BR read_named_attrs "\ (" R ),
> .BR write_named_attrs "\ (" W ),
> .BR synchronize "\ (" S ),
> .BR write_retention "\ (" e ),
> .BR write_retention_hold "\ (" E ):

If you follow my .TP suggestion above, then the above lines would need
to be rewritten sometinh like:

=2EBR read_named_attrs "\ (" R "), " write_named_attrs "\ (" W "), " \
synchronize "\ (" S "), " write_retention "\ (" e "), " \
write_retention_hold "\ (" E )

> These permissions are defined by NFSv4 / NFSv4.1.  They can be stored=
, but are
> not used.
> .RE

If you follow my suggestion above, delete the preceding .RE and
add .PP

>=20
> For the
> .BR r ", " w ", and " p
> permissions which have different long forms for files and directories=
, the
> .BR getrichacl (1)
> utility will output the appropriate form(s) depending on the context.
> The
> .BR setrichacl (1)
> utility will accept either form for any file type.
>=20
> .SS Text form
> The common textual representation of a RichACL consists of the colon-=
separated
> fields of the the ACL flags, file masks, and ACL entries in the follo=
wing

s/the the/the/

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
 \fIwho\fR
> field has no prefix for special identifiers, a
> .B user:
> or
> .B u:
> prefix for regular users, and a
> .B group:
> or
> .B g:
> prefix for regular groups.

I think the preceding sentence could be clearer. How about something
like the following (if correct):

[[
The who field is one of the following:

* One of the special identifiers: owner@, group@, or everyone@
* A user: or u: prefix followed by a [user name, user ID?] that designa=
tes
  s specific user
* A group: or g: prefix followed by a [group name, group ID?] that desi=
gnates
  s specific group
]]

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
> The access permissions for a file can either be set by assigning an a=
ccess
> control list
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
> is not stored.  (When the ACL of a file is requested which doesn't ha=
ve an ACL,
> the file mode permission bits are converted into an equivalent ACL.)
>=20
> .SS Changing the file mode permission bits
> When changing the file mode permission bits with
> .BR chmod (1),
> the owner, group,
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
> .SS Permissions at file-creation time
> When a directory has inheritable ACL entries, the following
> happens when a file or directory is created inside that directory:
> .RS 4
> .IP 1. 4
> A file created inside that directory will inherit all of the ACL entr=
ies that
> have the
> .B file_inherit
> flag set, and all inheritance-related flags in the inherited entries =
will be
> cleared.
>=20
> A subdirectory created inside that directory will inherit all of the =
ACL
> entries that have the
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
> the section
> .IR "Computing the maximum file masks" .
> .IP 4.
> The three sets of permissions for the owner, the group, and for other=
s in
> the \fImode\fR parameter as given to
> .BR open (2),
> .BR mkdir (2),
> and similar are converted into sets of RichACL permissions as describ=
ed in
> the section
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
> created inside that directory will not be assigned access control lis=
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
> standard system calls for creating files an directories (

s/an /and /
s/ ($//

> .BR creat (2),

Make that last line:

=2ERM ( creat (2),

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
> Automatic Inheritance still remains useful for network protocols like=
 NFSv4 and
> SMB, which both support creating files and directories without defini=
ng which

s/which$/their/

> permissions: they can implement those operations by using the standar=
d system
> calls and by then undoing the effect of applying the mode parameters.
>=20
> When the ACL of a directory is changed, the following happens for eac=
h entry
> (\(lqchild\(rq) inside that directory:
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
> .IP \(bu 4
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
> .RE
> .IP b)
> If any of the following is true:
> .RS 4
> .IP \(bu 4
> the requesting process is the file owner and the owner mask does not =
include all
> requested permissions,
> .IP \(bu 4
> the requesting process is not the file owner and it is in the owning =
group or
> matches any ACL entries other than
> .BR everyone@ ,
> and the group mask does not include all requested permissions,
> .IP \(bu 4
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
> Set the remaining permissions to the requested permissions.  Go throu=
gh all ACL
> entries. For each entry:
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
> .IP \(bu 4
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
>=20
> .\" .SH BUGS
> .SH AUTHOR
> Written by Andreas Gr=C3=BCnbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>.
>=20
> Please send your bug reports, suggested features and comments to the =
above address.

Could we start with just a few simple examples already, and build up
over future iterations of this page?

> .SH CONFORMING TO
> Rich Access Control Lists are Linux-specific.
> .SH SEE ALSO
> .BR acl (5),
> .BR chmod (1),
> .BR getrichacl (1),
> .BR ls (1),
> .BR setrichacl (1)
> .BR stat (2),
> .BR umask (2)
> .\" librichacl

Thanks,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
