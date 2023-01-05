function out = model
%
% Comsol_SaveAsOutput.m
%
% Model exported on Oct 29 2022, 14:48 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('E:\MATLAB\Tutorial\Models');

model.label('Comsol_TubeSlit.mph');

model.param.set('H', '0.2');
model.param.set('L', '0.5');
model.param.set('L_PML', '0.3');
model.param.set('L_QWR', '0.3');
model.param.set('H_QWR', '0.05');
model.param.set('Rho0', '1.213');
model.param.set('c0', '341.930');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.result.table.create('tbl1', 'Table');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').label('PML');
model.component('comp1').geom('geom1').feature('r1').set('pos', {'-L_PML' '0'});
model.component('comp1').geom('geom1').feature('r1').set('size', {'L_PML' 'H'});
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').label('Duct');
model.component('comp1').geom('geom1').feature('r2').set('pos', [0 0]);
model.component('comp1').geom('geom1').feature('r2').set('size', {'L' 'H'});
model.component('comp1').geom('geom1').create('r3', 'Rectangle');
model.component('comp1').geom('geom1').feature('r3').label('SWR');
model.component('comp1').geom('geom1').feature('r3').set('pos', {'L' '0.075'});
model.component('comp1').geom('geom1').feature('r3').set('size', {'L_QWR' 'H_QWR'});
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup('def').func.create('eta', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('Cp', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('rho', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('k', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('cs', 'Analytic');

model.component('comp1').coordSystem.create('pml1', 'PML');
model.component('comp1').coordSystem('pml1').selection.set([1]);

model.component('comp1').physics.create('acpr', 'PressureAcoustics', 'geom1');
model.component('comp1').physics('acpr').create('bpf1', 'BackgroundPressureField', 2);
model.component('comp1').physics('acpr').feature('bpf1').selection.set([2]);

model.component('comp1').mesh('mesh1').autoMeshSize(2);

model.result.table('tbl1').label('Probe Table 1');

model.component('comp1').view('view1').axis.set('xmin', -0.5285972952842712);
model.component('comp1').view('view1').axis.set('xmax', 1.028597354888916);
model.component('comp1').view('view1').axis.set('ymin', -0.6798928380012512);
model.component('comp1').view('view1').axis.set('ymax', 0.879892885684967);

model.component('comp1').material('mat1').label('Air');
model.component('comp1').material('mat1').set('family', 'air');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/R_const[K*mol/J]/T');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('dermethod', 'manual');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('argders', {'pA' 'd(pA*0.02897/R_const/T,pA)'; 'T' 'd(pA*0.02897/R_const/T,T)'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('plotargs', {'pA' '0' '1'; 'T' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*287*T)');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('args', {'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('dermethod', 'manual');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('argders', {'T' 'd(sqrt(1.4*287*T),T)'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('plotargs', {'T' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
model.component('comp1').material('mat1').propertyGroup('def').set('ratioofspecificheat', '1.4');
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'0[S/m]' '0' '0' '0' '0[S/m]' '0' '0' '0' '0[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
model.component('comp1').material('mat1').propertyGroup('def').set('density', 'rho(pA[1/Pa],T[1/K])[kg/m^3]');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
model.component('comp1').material('mat1').propertyGroup('def').addInput('temperature');
model.component('comp1').material('mat1').propertyGroup('def').addInput('pressure');

model.component('comp1').physics('acpr').feature('bpf1').set('pamp', 1);
model.component('comp1').physics('acpr').feature('bpf1').set('c_mat', 'from_mat');

model.study.create('std1');
model.study('std1').create('freq', 'Frequency');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('pDef', 'Parametric');
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');

model.result.create('pg1', 'PlotGroup2D');
model.result.create('pg2', 'PlotGroup2D');
model.result('pg1').create('surf1', 'Surface');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('expr', 'acpr.Lp');

model.study('std1').feature('freq').set('plist', '5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 69, 71, 73, 75, 77, 79, 81, 83, 85, 87, 89, 91, 93, 95, 97, 99, 101, 103, 105, 107, 109, 111, 113, 115, 117, 119, 121, 123, 125, 127, 129, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 161, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 193, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255, 257, 259, 261, 263, 265, 267, 269, 271, 273, 275, 277, 279, 281, 283, 285, 287, 289, 291, 293, 295, 297, 299, 301, 303, 305, 307, 309, 311, 313, 315, 317, 319, 321, 323, 325, 327, 329, 331, 333, 335, 337, 339, 341, 343, 345, 347, 349, 351, 353, 355, 357, 359, 361, 363, 365, 367, 369, 371, 373, 375, 377, 379, 381, 383, 385, 387, 389, 391, 393, 395, 397, 399, 401, 403, 405, 407, 409, 411, 413, 415, 417, 419, 421, 423, 425, 427, 429, 431, 433, 435, 437, 439, 441, 443, 445, 447, 449, 451, 453, 455, 457, 459, 461, 463, 465, 467, 469, 471, 473, 475, 477, 479, 481, 483, 485, 487, 489, 491, 493, 495, 497, 499, 501, 503, 505, 507, 509, 511, 513, 515, 517, 519, 521, 523, 525, 527, 529, 531, 533, 535, 537, 539, 541, 543, 545, 547, 549, 551, 553, 555, 557, 559, 561, 563, 565, 567, 569, 571, 573, 575, 577, 579, 581, 583, 585, 587, 589, 591, 593, 595, 597, 599, 601, 603, 605, 607, 609, 611, 613, 615, 617, 619, 621, 623, 625, 627, 629, 631, 633, 635, 637, 639, 641, 643, 645, 647, 649, 651, 653, 655, 657, 659, 661, 663, 665, 667, 669, 671, 673, 675, 677, 679, 681, 683, 685, 687, 689, 691, 693, 695, 697, 699, 701, 703, 705, 707, 709, 711, 713, 715, 717, 719, 721, 723, 725, 727, 729, 731, 733, 735, 737, 739, 741, 743, 745, 747, 749, 751, 753, 755, 757, 759, 761, 763, 765, 767, 769, 771, 773, 775, 777, 779, 781, 783, 785, 787, 789, 791, 793, 795, 797, 799, 801, 803, 805, 807, 809, 811, 813, 815, 817, 819, 821, 823, 825, 827, 829, 831, 833, 835, 837, 839, 841, 843, 845, 847, 849, 851, 853, 855, 857, 859, 861, 863, 865, 867, 869, 871, 873, 875, 877, 879, 881, 883, 885, 887, 889, 891, 893, 895, 897, 899, 901, 903, 905, 907, 909, 911, 913, 915, 917, 919, 921, 923, 925, 927, 929, 931, 933, 935, 937, 939, 941, 943, 945, 947, 949, 951, 953, 955, 957, 959, 961, 963, 965, 967, 969, 971, 973, 975, 977, 979, 981, 983, 985, 987, 989, 991, 993, 995, 997, 999');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('v1').set('clistctrl', {'p1'});
model.sol('sol1').feature('v1').set('cname', {'freq'});
model.sol('sol1').feature('v1').set('clist', {'5[Hz] 7[Hz] 9[Hz] 11[Hz] 13[Hz] 15[Hz] 17[Hz] 19[Hz] 21[Hz] 23[Hz] 25[Hz] 27[Hz] 29[Hz] 31[Hz] 33[Hz] 35[Hz] 37[Hz] 39[Hz] 41[Hz] 43[Hz] 45[Hz] 47[Hz] 49[Hz] 51[Hz] 53[Hz] 55[Hz] 57[Hz] 59[Hz] 61[Hz] 63[Hz] 65[Hz] 67[Hz] 69[Hz] 71[Hz] 73[Hz] 75[Hz] 77[Hz] 79[Hz] 81[Hz] 83[Hz] 85[Hz] 87[Hz] 89[Hz] 91[Hz] 93[Hz] 95[Hz] 97[Hz] 99[Hz] 101[Hz] 103[Hz] 105[Hz] 107[Hz] 109[Hz] 111[Hz] 113[Hz] 115[Hz] 117[Hz] 119[Hz] 121[Hz] 123[Hz] 125[Hz] 127[Hz] 129[Hz] 131[Hz] 133[Hz] 135[Hz] 137[Hz] 139[Hz] 141[Hz] 143[Hz] 145[Hz] 147[Hz] 149[Hz] 151[Hz] 153[Hz] 155[Hz] 157[Hz] 159[Hz] 161[Hz] 163[Hz] 165[Hz] 167[Hz] 169[Hz] 171[Hz] 173[Hz] 175[Hz] 177[Hz] 179[Hz] 181[Hz] 183[Hz] 185[Hz] 187[Hz] 189[Hz] 191[Hz] 193[Hz] 195[Hz] 197[Hz] 199[Hz] 201[Hz] 203[Hz] 205[Hz] 207[Hz] 209[Hz] 211[Hz] 213[Hz] 215[Hz] 217[Hz] 219[Hz] 221[Hz] 223[Hz] 225[Hz] 227[Hz] 229[Hz] 231[Hz] 233[Hz] 235[Hz] 237[Hz] 239[Hz] 241[Hz] 243[Hz] 245[Hz] 247[Hz] 249[Hz] 251[Hz] 253[Hz] 255[Hz] 257[Hz] 259[Hz] 261[Hz] 263[Hz] 265[Hz] 267[Hz] 269[Hz] 271[Hz] 273[Hz] 275[Hz] 277[Hz] 279[Hz] 281[Hz] 283[Hz] 285[Hz] 287[Hz] 289[Hz] 291[Hz] 293[Hz] 295[Hz] 297[Hz] 299[Hz] 301[Hz] 303[Hz] 305[Hz] 307[Hz] 309[Hz] 311[Hz] 313[Hz] 315[Hz] 317[Hz] 319[Hz] 321[Hz] 323[Hz] 325[Hz] 327[Hz] 329[Hz] 331[Hz] 333[Hz] 335[Hz] 337[Hz] 339[Hz] 341[Hz] 343[Hz] 345[Hz] 347[Hz] 349[Hz] 351[Hz] 353[Hz] 355[Hz] 357[Hz] 359[Hz] 361[Hz] 363[Hz] 365[Hz] 367[Hz] 369[Hz] 371[Hz] 373[Hz] 375[Hz] 377[Hz] 379[Hz] 381[Hz] 383[Hz] 385[Hz] 387[Hz] 389[Hz] 391[Hz] 393[Hz] 395[Hz] 397[Hz] 399[Hz] 401[Hz] 403[Hz] 405[Hz] 407[Hz] 409[Hz] 411[Hz] 413[Hz] 415[Hz] 417[Hz] 419[Hz] 421[Hz] 423[Hz] 425[Hz] 427[Hz] 429[Hz] 431[Hz] 433[Hz] 435[Hz] 437[Hz] 439[Hz] 441[Hz] 443[Hz] 445[Hz] 447[Hz] 449[Hz] 451[Hz] 453[Hz] 455[Hz] 457[Hz] 459[Hz] 461[Hz] 463[Hz] 465[Hz] 467[Hz] 469[Hz] 471[Hz] 473[Hz] 475[Hz] 477[Hz] 479[Hz] 481[Hz] 483[Hz] 485[Hz] 487[Hz] 489[Hz] 491[Hz] 493[Hz] 495[Hz] 497[Hz] 499[Hz] 501[Hz] 503[Hz] 505[Hz] 507[Hz] 509[Hz] 511[Hz] 513[Hz] 515[Hz] 517[Hz] 519[Hz] 521[Hz] 523[Hz] 525[Hz] 527[Hz] 529[Hz] 531[Hz] 533[Hz] 535[Hz] 537[Hz] 539[Hz] 541[Hz] 543[Hz] 545[Hz] 547[Hz] 549[Hz] 551[Hz] 553[Hz] 555[Hz] 557[Hz] 559[Hz] 561[Hz] 563[Hz] 565[Hz] 567[Hz] 569[Hz] 571[Hz] 573[Hz] 575[Hz] 577[Hz] 579[Hz] 581[Hz] 583[Hz] 585[Hz] 587[Hz] 589[Hz] 591[Hz] 593[Hz] 595[Hz] 597[Hz] 599[Hz] 601[Hz] 603[Hz] 605[Hz] 607[Hz] 609[Hz] 611[Hz] 613[Hz] 615[Hz] 617[Hz] 619[Hz] 621[Hz] 623[Hz] 625[Hz] 627[Hz] 629[Hz] 631[Hz] 633[Hz] 635[Hz] 637[Hz] 639[Hz] 641[Hz] 643[Hz] 645[Hz] 647[Hz] 649[Hz] 651[Hz] 653[Hz] 655[Hz] 657[Hz] 659[Hz] 661[Hz] 663[Hz] 665[Hz] 667[Hz] 669[Hz] 671[Hz] 673[Hz] 675[Hz] 677[Hz] 679[Hz] 681[Hz] 683[Hz] 685[Hz] 687[Hz] 689[Hz] 691[Hz] 693[Hz] 695[Hz] 697[Hz] 699[Hz] 701[Hz] 703[Hz] 705[Hz] 707[Hz] 709[Hz] 711[Hz] 713[Hz] 715[Hz] 717[Hz] 719[Hz] 721[Hz] 723[Hz] 725[Hz] 727[Hz] 729[Hz] 731[Hz] 733[Hz] 735[Hz] 737[Hz] 739[Hz] 741[Hz] 743[Hz] 745[Hz] 747[Hz] 749[Hz] 751[Hz] 753[Hz] 755[Hz] 757[Hz] 759[Hz] 761[Hz] 763[Hz] 765[Hz] 767[Hz] 769[Hz] 771[Hz] 773[Hz] 775[Hz] 777[Hz] 779[Hz] 781[Hz] 783[Hz] 785[Hz] 787[Hz] 789[Hz] 791[Hz] 793[Hz] 795[Hz] 797[Hz] 799[Hz] 801[Hz] 803[Hz] 805[Hz] 807[Hz] 809[Hz] 811[Hz] 813[Hz] 815[Hz] 817[Hz] 819[Hz] 821[Hz] 823[Hz] 825[Hz] 827[Hz] 829[Hz] 831[Hz] 833[Hz] 835[Hz] 837[Hz] 839[Hz] 841[Hz] 843[Hz] 845[Hz] 847[Hz] 849[Hz] 851[Hz] 853[Hz] 855[Hz] 857[Hz] 859[Hz] 861[Hz] 863[Hz] 865[Hz] 867[Hz] 869[Hz] 871[Hz] 873[Hz] 875[Hz] 877[Hz] 879[Hz] 881[Hz] 883[Hz] 885[Hz] 887[Hz] 889[Hz] 891[Hz] 893[Hz] 895[Hz] 897[Hz] 899[Hz] 901[Hz] 903[Hz] 905[Hz] 907[Hz] 909[Hz] 911[Hz] 913[Hz] 915[Hz] 917[Hz] 919[Hz] 921[Hz] 923[Hz] 925[Hz] 927[Hz] 929[Hz] 931[Hz] 933[Hz] 935[Hz] 937[Hz] 939[Hz] 941[Hz] 943[Hz] 945[Hz] 947[Hz] 949[Hz] 951[Hz] 953[Hz] 955[Hz] 957[Hz] 959[Hz] 961[Hz] 963[Hz] 965[Hz] 967[Hz] 969[Hz] 971[Hz] 973[Hz] 975[Hz] 977[Hz] 979[Hz] 981[Hz] 983[Hz] 985[Hz] 987[Hz] 989[Hz] 991[Hz] 993[Hz] 995[Hz] 997[Hz] 999[Hz]'});
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature('pDef').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('pDef').set('plistarr', {'5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 69, 71, 73, 75, 77, 79, 81, 83, 85, 87, 89, 91, 93, 95, 97, 99, 101, 103, 105, 107, 109, 111, 113, 115, 117, 119, 121, 123, 125, 127, 129, 131, 133, 135, 137, 139, 141, 143, 145, 147, 149, 151, 153, 155, 157, 159, 161, 163, 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189, 191, 193, 195, 197, 199, 201, 203, 205, 207, 209, 211, 213, 215, 217, 219, 221, 223, 225, 227, 229, 231, 233, 235, 237, 239, 241, 243, 245, 247, 249, 251, 253, 255, 257, 259, 261, 263, 265, 267, 269, 271, 273, 275, 277, 279, 281, 283, 285, 287, 289, 291, 293, 295, 297, 299, 301, 303, 305, 307, 309, 311, 313, 315, 317, 319, 321, 323, 325, 327, 329, 331, 333, 335, 337, 339, 341, 343, 345, 347, 349, 351, 353, 355, 357, 359, 361, 363, 365, 367, 369, 371, 373, 375, 377, 379, 381, 383, 385, 387, 389, 391, 393, 395, 397, 399, 401, 403, 405, 407, 409, 411, 413, 415, 417, 419, 421, 423, 425, 427, 429, 431, 433, 435, 437, 439, 441, 443, 445, 447, 449, 451, 453, 455, 457, 459, 461, 463, 465, 467, 469, 471, 473, 475, 477, 479, 481, 483, 485, 487, 489, 491, 493, 495, 497, 499, 501, 503, 505, 507, 509, 511, 513, 515, 517, 519, 521, 523, 525, 527, 529, 531, 533, 535, 537, 539, 541, 543, 545, 547, 549, 551, 553, 555, 557, 559, 561, 563, 565, 567, 569, 571, 573, 575, 577, 579, 581, 583, 585, 587, 589, 591, 593, 595, 597, 599, 601, 603, 605, 607, 609, 611, 613, 615, 617, 619, 621, 623, 625, 627, 629, 631, 633, 635, 637, 639, 641, 643, 645, 647, 649, 651, 653, 655, 657, 659, 661, 663, 665, 667, 669, 671, 673, 675, 677, 679, 681, 683, 685, 687, 689, 691, 693, 695, 697, 699, 701, 703, 705, 707, 709, 711, 713, 715, 717, 719, 721, 723, 725, 727, 729, 731, 733, 735, 737, 739, 741, 743, 745, 747, 749, 751, 753, 755, 757, 759, 761, 763, 765, 767, 769, 771, 773, 775, 777, 779, 781, 783, 785, 787, 789, 791, 793, 795, 797, 799, 801, 803, 805, 807, 809, 811, 813, 815, 817, 819, 821, 823, 825, 827, 829, 831, 833, 835, 837, 839, 841, 843, 845, 847, 849, 851, 853, 855, 857, 859, 861, 863, 865, 867, 869, 871, 873, 875, 877, 879, 881, 883, 885, 887, 889, 891, 893, 895, 897, 899, 901, 903, 905, 907, 909, 911, 913, 915, 917, 919, 921, 923, 925, 927, 929, 931, 933, 935, 937, 939, 941, 943, 945, 947, 949, 951, 953, 955, 957, 959, 961, 963, 965, 967, 969, 971, 973, 975, 977, 979, 981, 983, 985, 987, 989, 991, 993, 995, 997, 999'});
model.sol('sol1').feature('s1').feature('pDef').set('punit', {'Hz'});
model.sol('sol1').feature('s1').feature('pDef').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('pDef').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('pDef').set('uselsqdata', false);
model.sol('sol1').feature('s1').feature('p1').set('control', 'user');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'5    7    9   11   13   15   17   19   21   23   25   27   29   31   33   35   37   39   41   43   45   47   49   51   53   55   57   59   61   63   65   67   69   71   73   75   77   79   81   83   85   87   89   91   93   95   97   99  101  103  105  107  109  111  113  115  117  119  121  123  125  127  129  131  133  135  137  139  141  143  145  147  149  151  153  155  157  159  161  163  165  167  169  171  173  175  177  179  181  183  185  187  189  191  193  195  197  199  201  203  205  207  209  211  213  215  217  219  221  223  225  227  229  231  233  235  237  239  241  243  245  247  249  251  253  255  257  259  261  263  265  267  269  271  273  275  277  279  281  283  285  287  289  291  293  295  297  299  301  303  305  307  309  311  313  315  317  319  321  323  325  327  329  331  333  335  337  339  341  343  345  347  349  351  353  355  357  359  361  363  365  367  369  371  373  375  377  379  381  383  385  387  389  391  393  395  397  399  401  403  405  407  409  411  413  415  417  419  421  423  425  427  429  431  433  435  437  439  441  443  445  447  449  451  453  455  457  459  461  463  465  467  469  471  473  475  477  479  481  483  485  487  489  491  493  495  497  499  501  503  505  507  509  511  513  515  517  519  521  523  525  527  529  531  533  535  537  539  541  543  545  547  549  551  553  555  557  559  561  563  565  567  569  571  573  575  577  579  581  583  585  587  589  591  593  595  597  599  601  603  605  607  609  611  613  615  617  619  621  623  625  627  629  631  633  635  637  639  641  643  645  647  649  651  653  655  657  659  661  663  665  667  669  671  673  675  677  679  681  683  685  687  689  691  693  695  697  699  701  703  705  707  709  711  713  715  717  719  721  723  725  727  729  731  733  735  737  739  741  743  745  747  749  751  753  755  757  759  761  763  765  767  769  771  773  775  777  779  781  783  785  787  789  791  793  795  797  799  801  803  805  807  809  811  813  815  817  819  821  823  825  827  829  831  833  835  837  839  841  843  845  847  849  851  853  855  857  859  861  863  865  867  869  871  873  875  877  879  881  883  885  887  889  891  893  895  897  899  901  903  905  907  909  911  913  915  917  919  921  923  925  927  929  931  933  935  937  939  941  943  945  947  949  951  953  955  957  959  961  963  965  967  969  971  973  975  977  979  981  983  985  987  989  991  993  995  997  999'});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').runAll;

model.result('pg1').label('Acoustic Pressure (acpr)');
model.result('pg1').feature('surf1').set('colortable', 'WaveLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg2').label('Sound Pressure Level (acpr)');
model.result('pg2').feature('surf1').set('resolution', 'normal');

out = model;
