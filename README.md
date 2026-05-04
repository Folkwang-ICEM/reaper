# reaper

All decoder presets use the loudspeaker positions of the Neue Aula and ICEM's
studios. For software that can calculate angles for these from distances, see
ambi-speakers.lsp in the Lisp repository.

For concerts in the Neue Aula (from 14/11/2024) the default deocder should be
iem-decoder-neue-aula-5-front-plus-rear-centre-with-fills.json

Note that as of 2.7.24 the channel order for Folkwang's *Beschallung* team is
essentially that which I proposed in order to be approximately Atmos-ready
(thanks Charles). The channels on the left, below, are the correct Dante
channels to route for the *Beschallung* team; those in parentheses on the right
are the SAD-P Dante input channels, for info only, i.e. not to be used by ICEM.

01: Vida Vorne L                (31)  
02: Vida Vorne R                (32)  
03: Centre                      (33)  
04: Sub                         (34)   
05: Vida Hinten L               (35)  
06: Vida Hinten R               (36)  

07: Seite Links Vorn            (37)  
08: Seite Rechts Vorn           (38)  
09: Seite Links Hinten          (39)  
10: Seite Rechts Hinten         (40)  
11: Seite Links Mitte           (41)  
12: Seite Rechts Mitte          (42)  

13: Decke Links Vorn            (43)  
14: Decke Rechts Vorn           (44)  
15: Decke Links Hinten          (45)  
16: Decke Rechts Hinten         (46)  
17: Decke Links Mitte           (47)  
18: Decke Rechts Mitte          (48)  

19: Centre Links                (49)  
20: Centre Rechts               (50)  
21: Hinten Mitte                (51)  

22: Frontfill LL                (52)  
23: Frontfill L                 (53)  
24: Frontfill C                 (54)  
25: Frontfill R                 (55)  
26: Frontfill RR                (56)  
27: Empore LL                   (57)  
28: Empore L                    (58)  
29: Empore R                    (59)  
30: Empore RR                   (60)

If you want to test the Neue Aula speaker channels, you can use the following
reaper file from this repository: ambi5th-speaker-routing-spoken.RPP The
required sound files are at
https://icem.folkwang-uni.de/~mde/neue-aula-spoken.zip

# AED format for left-inlet of ICST's ambimonitor max external
aed 1 -39.094 18.755 1.0, aed 2 39.094 18.755 1.0, aed 3 -0.000 26.565 1.0, aed 5 -153.435 6.954 1.0, aed 6 -206.565 6.954 1.0, aed 7 -63.435 29.206 1.0, aed 8 63.435 29.206 1.0, aed 9 -116.565 29.206 1.0, aed 10 -243.435 29.206 1.0, aed 11 -90.000 32.005 1.0, aed 12 90.000 32.005 1.0, aed 13 -36.870 57.995 1.0, aed 14 36.870 57.995 1.0, aed 15 -143.130 57.995 1.0, aed 16 -216.870 57.995 1.0, aed 17 -90.000 69.444 1.0, aed 18 90.000 69.444 1.0, aed 19 -20.0 25.0 1.0, aed 20 20 25 1.0, aed 21 180.0 17.853 1.0, aed 22 -32.735 -3.438 1.0, aed 23 -17.819 -3.89 1.0,aed 24 0.0 -3.89 1, aed 25 17.819 -3.890 1.0, aed 26 32.735 -3.438 1.0, aed 27 -143.973 22.017 1.0, aed 28 -160.017 25.169 1.0, aed 29 160.017 25.269 1.0, aed 30 143.973 22.017 1.0

# atmos-like decoder presets

The Neue Aula Atmos-like presets (e.g. iem-decoder-neue-aula-7.4.json) are
offered merely for rendering a lower channel-count file from an Ambisonics
project so that, for example, you can play out of software such as QLab (which
is currently limited to 24 audio channels maximum). These decoders use the Neue
Aula loudspeaker positions so should not be used for an actual Atmos file
render, as Atmos uses different loudspeaker positions.

Note also two more things:

1) the channel numbers out of the Atmos-like decoders are simply consecutive,
i.e. they skip the LFE channel 4 so that you don't render unnecessary silent
channels. Take care of mapping to the actual speakers being used, e.g. with four
tops in e.g. 7.4, the middle top pair of the Neue Aula is not used; for the
sides in 7.4, the front side pair is not used; for the sides in 9.4, the middle
side pair is not used. All of this could be reconfigured of course, by making a
new decoder and deleting speakers from
e.g. iem-decoder-neue-aula-3-front-plus-rear-centre-no-fills.json.

2) as the LFE channel is skipped in the Atmos-like decoders, you'll need to use
e.g. SAD-P/Reaper/a mixing desk in order to make a send for the LFE on channel
4.

# studio 1 reaSurroundPan coordinates
These are also presented in a near-atmos channel
order. reaSurroundPanPresets.RPL now includes '1 in to studio 1' where instead
of the ring-like channel order surround/atmos order is used for the ease of
mapping such sound files directly to the studio 1 speakers. This means that
plugin-pins handle the mapping of surround/atmos channel numbers to studio 1
speaker channel numbers.

plugin channel.surround/atmos label = studio 1 channel
1. L = 13
2. R = 14
3. C = 5
4. (LFE = 21)
5. Ls = 18
6. Rs = 17
7. L side = 19
8. R side = 16
9. Top L = 9
10. Top R = 10
11. Top Ls = 12
12. Top Rs = 11
13. Top L mid = 8
14. Top R mid = 6
15. L wide = 20
16. R wide = 15
17. top rear centre = 7

Actual speaker channels and XYZ coordinates
Out_013 << (-47,95,0) 
Out_014 << (47,95,0) 
Out_015 << (97,40,0) 
Out_016 << (97,-40,0) 
Out_017 << (40,-97,0) 
Out_018 << (-40,-97,0) 
Out_019 << (-97,-40,0) 
Out_020 << (-97,40,0) 
Out_005 << (0,100,72) 
Out_006 << (100,0,72) 
Out_007 << (0,-100,72) 
Out_008 << (-100,0,72) 
Out_009 << (-42,42,100) 
Out_010 << (44,42,100) 
Out_011 << (44,-42,100) 
Out_012 << (-44,-42,100) 


Michael Edwards, July 13th 2024
Updated November 14th 2024 to reflect the two new speakers at the front
(Centre Left and Centre Right)
Updated May 3rd 2026 to reflect new studio 1 measurements and the reaSurroundPan
coordinates 

## Generic decoder presets

The sub-directory `generic/` in the `decoder-panner-presets` collection contains
decoder presets modeled after the speaker setup guides provided by Dolby
(https://www.dolby.com/about/support/guide/speaker-setup-guides/).  As the
aforementioned presets, they are aimed at working with Ambisonics-mixes in a
context which requires audio rendered to discrete channels (e.g. when creating
an Atmos-bed from an HOA file). 

Ruben Philipp, October 10th 2024
