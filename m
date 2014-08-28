From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH V4 1/8] namespaces: assign each namespace instance a
	serial number
Date: Thu, 28 Aug 2014 15:05:00 -0500
Message-ID: <87tx4wmlcj.fsf@x220.int.ebiederm.org>
References: <cover.1408581429.git.rgb@redhat.com>
	<cover.1408581429.git.rgb@redhat.com>
	<d5bfd81a219c5c45c910494d6a3478ce83052e1f.1408581429.git.rgb@redhat.com>
	<87ioljs968.fsf@x220.int.ebiederm.org>
	<20140824203827.GI9003@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20140824203827.GI9003-bcJWsdo4jJjeVoXN4CMphl7TgLCtbB0G@public.gmane.org> (Richard Guy
	Briggs's message of "Sun, 24 Aug 2014 16:38:27 -0400")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> On 14/08/23, Eric W. Biederman wrote:
>> Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>> 
>> > Generate and assign a serial number per namespace instance since boot.
>> >
>> > Use a serial number per namespace (unique across one boot of one kernel)
>> > instead of the inode number (which is claimed to have had the right to change
>> > reserved and is not necessarily unique if there is more than one proc fs) to
>> > uniquely identify it per kernel boot.
>> 
>> This approach is just broken.
>> 
>> For this to work with migration (aka criu) you need to implement a
>> namespace of namespaces.  You haven't done this, and therefore
>> such an interface will break existing userspace.
>> 
>> Inside of audit I can understand not caring about these issues,
>> but you go foward and expose these serial numbers in proc,
>> and generally make this infrastructure available to others.
>> 
>> The deep issue with migration is that we move tasks from one machine
>> from another and on the destination machine we need to have all of the
>> same global identifiers for software to function properly.
>> 
>> My weasel words around the proc inode numbers is to preserve to allow us
>> room to be able to restore those ids if it every becomes relevant for
>> migration.
>
> What do you do if the inode number is already in use on the target
> host?

Since the inode numbers are relative to a superblock or a pid namespace
the numbers that are in use can be restored on the target system
by creating them in the appropriate namespace.

The support does not exist in the kernel today for doing that because no
one has cared but as architected the support can be added if needed to
support migration.

>> That is the proc inode numbers (technically) live in a pid namespace,
>> (aka a mount of proc).  So depending on the pid namespace you are in
>> or the mount of proc you look in the numbers could change.
>> 
>> Qualifications like that must exist to have a prayer of ever supporting
>> process migration in the crazy corner cases where people start caring
>> about inode numbers.
>> 
>> We currently don't and inode numbers for a namespace will never change
>> after a namespace is created.  So I think you really are ok using the
>> proc inode numbers.  I am happy declaring by fiat that the inode numbers
>> that audit uses are the numbers connected to the initial pid namespace.
>
> But once a namespace/container is migrated, it is a different audit that
> is looking at it (unless we create an audit manager or entity that
> functions at the level of a container manager), so audit should not care.

These numbers were exported to everyone as a general purpose facility in
proc.  If audit is global and audit doesn't migrate you are right it
doesn't matter.  However if these numbers are used by anyone else for
anything else it causes a problem.

Further given that people run entire distributions in containers we may
reach the point where we wish to run auditd in a container in the
future.  I would hate to paint ourselves into a corner with a design
that could never allow audit to migrate.  Support that case someday
seems a valid naive desire.

>> At a fairly basic level anything that is used to identify namespaces for
>> any general purpose use needs to have most if not all of the same
>> properties of the proc inode numbers.  The most important of which is
>> being tied to some context/namespace so there is a ability if we ever
>> need it to migrate those numbers from one machine to another.
>
> Sooo...  does it make any sense to have those inode or serial numbers be
> blank inside the namespace/container itself, but only visible to its
> manager outside the container (unless it is the initial namespace)?

Mostly I think it makes sense to use the inode numbers from the initial
pid namespace.  They already exist.  They already are unique.  (Which
means I don't need to maintain more code and more special cases).  And
the do what you need now.

I probably haven't followed closely enough but I don't see what makes
inode numbers undesirable.

Eric
